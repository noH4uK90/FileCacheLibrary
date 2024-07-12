//
//  CSVable.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

public protocol CSVable {
    static var fieldNames: [String] { get }
    var csv: (Character) -> String { get }
    
    static func csvHeader(separator: Character) -> String
    static func parse(csv: String, separator: Character) -> Self?
}