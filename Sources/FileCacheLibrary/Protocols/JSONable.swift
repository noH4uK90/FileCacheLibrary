//
//  JSONable.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol JSONable: Identifiable {
    var json: Any { get }
    
    static func parse(json: Any) -> Self?
}
