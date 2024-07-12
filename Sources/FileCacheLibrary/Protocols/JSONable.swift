//
//  JSONable.swift
//  
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

public protocol JSONable {
    var json: Any { get }
    
    static func parse(json: Any) -> Self?
}
