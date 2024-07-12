// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class FileCacheLibrary<T: JSONable & CSVable> {
    
    private let fileManager = FileManager.default
    
    public init() {}
    
    /**
     Saves an array of objects to a file with the specified name and extension.
     
     - Parameters:
       - objects: The array of objects to save.
       - fileName: The name of the file (default is "todos").
       - fileExtension: The extension of the file (default is .json).
       - separator: The separator character for CSV files (default is ";").
     */
    public func saveToFile(_ objects: [T], to fileName: String = "todos", extension fileExtension: FileExtension = .json, _ separator: Character = ";") throws {
        do {
            let path = try getFileURL(fileName: fileName, fileExtension: fileExtension)
            switch fileExtension {
            case .json:
                try saveJSON(objects, to: path)
            case .csv:
                try saveCSV(objects, to: path, separator)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    /**
     Exports an array of objects from a file with the specified name and extension.
     
     - Parameters:
       - fileName: The name of the file (default is "todos").
       - fileExtension: The extension of the file (default is .json).
       - separator: The separator character for CSV files (default is ";").
     - Returns: An array of objects read from the file.
     */
    public func exportFromFile(from fileName: String = "todos", extension fileExtension: FileExtension = .json, _ separator: Character = ";") throws -> [T] {
        do {
            let path = try getFileURL(fileName: fileName, fileExtension: fileExtension)
            switch fileExtension {
            case .json:
                return try exportJSON(from: path)
            case .csv:
                return try exportCSV(from: path, separator)
            }
        } catch {
            throw error
        }
    }
    
    private func getFileURL(fileName: String, fileExtension: FileExtension) throws -> URL {
        guard let fileManager = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileError.directoryNotFound(directory: "Document directory")
        }
        
        return fileManager
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension.rawValue)
    }
}

// MARK: Extension for work with JSON
private extension FileCacheLibrary {
    /**
     Saves an array of objects to a JSON file at the specified path.
     
     - Parameters:
       - objects: The array of objects to save.
       - path: The URL path where the file will be saved.
     - Throws: An error if the JSON serialization or file writing fails.
     */
    func saveJSON(_ objects: [T], to path: URL) throws {
        do {
            let json = objects.map { $0.json }
            
            if JSONSerialization.isValidJSONObject(json) == false {
                throw JSONError.notValidObject(object: """
                    \(json)
                """)
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: objects.map({ $0.json }), options: [])
            try jsonData.write(to: path)
        } catch let error as EncodingError {
            throw JSONError.jsonSerializationError(error)
        } catch {
            throw error
        }
    }
    
    /**
     Exports an array of objects from a JSON file at the specified path.
     
     - Parameter path: The URL path of the JSON file.
     - Returns: An array of objects read from the JSON file.
     - Throws: An error if the JSON deserialization or file reading fails.
     */
    func exportJSON(from path: URL) throws -> [T] {
        do {
            let data = try Data(contentsOf: path)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                return jsonArray.compactMap { T.parse(json: $0) }
            }
            
            return []
        } catch let error as DecodingError {
            throw JSONError.jsonSerializationError(error)
        } catch {
            throw error
        }
    }
}

// MARK: Extension for work with CSV
private extension FileCacheLibrary {
    
    /**
     Saves an array of objects to a CSV file at the specified path.
     
     - Parameters:
       - objects: The array of objects to save.
       - path: The URL path where the file will be saved.
       - separator: The separator character for CSV files.
     - Throws: An error if the CSV serialization or file writing fails.
     */
    func saveCSV(_ objects: [T], to path: URL, _ separator: Character) throws {
        var csv: [String] = [T.csvHeader(separator: separator)]
        
        objects.forEach { object in
            csv.append(object.csv(separator))
        }
        
        let csvString = csv.joined(separator: "\n")
        try csvString.write(to: path, atomically: false, encoding: .utf8)
    }
    
    /**
     Exports an array of objects from a CSV file at the specified path.
     
     - Parameters:
       - path: The URL path of the CSV file.
       - separator: The separator character for CSV files.
     - Returns: An array of objects read from the CSV file.
     - Throws: An error if the CSV deserialization or file reading fails.
     */
    func exportCSV(from path: URL, _ separator: Character) throws -> [T] {
        let csvString = try String(contentsOf: path, encoding: .utf8)
        var objects = csvString.split(separator: "\n").map({ String($0) })
        objects.removeFirst()
        return objects.compactMap { T.parse(csv: $0, separator: separator) }
    }
}
