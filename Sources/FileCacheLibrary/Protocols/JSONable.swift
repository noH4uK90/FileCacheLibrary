//
//  JSONable.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

@available(macOS 10.15, *)
public protocol JSONable: Identifiable {
    var json: Any { get }
    
    static func parse(json: Any) -> Self?
}
