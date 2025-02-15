//
//  CSVable.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol CSVable: Identifiable {
    static var fieldNames: [String] { get }
    var csv: (Character) -> String { get }
    
    static func csvHeader(separator: Character) -> String
    static func parse(csv: String, separator: Character) -> Self?
}
