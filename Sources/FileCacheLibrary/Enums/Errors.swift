//
//  Errors.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

public enum FileError: Error {
    case directoryNotFound(directory: String?)
    
    var localizedDescription: String {
        switch self {
        case .directoryNotFound(let directory):
            if let directory = directory {
                return "Directory not found: \(directory)"
            }
            return "Directory not found"
        }
    }
}

public enum JSONError: Error {
    case jsonSerializationError(Error)
    
    var localizedDescription: String {
        switch self {
        case .jsonSerializationError(let error):
            return "Serialization error: \(error.localizedDescription)"
        }
    }
}
