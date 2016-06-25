//
//  Array+Operators.swift
//
//  Created by Anish Kumar on 04/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation


/**
 Remove an element from the array
 */
public func - <T: Equatable> (first: [T], second: T) -> [T] {
    return first - [second]
}

/**
 Difference operator
 */
public func - <T: Equatable> (first: [T], second: [T]) -> [T] {
    return first.difference(second)
}

/**
 Intersection operator
 */
public func & <T: Equatable> (first: [T], second: [T]) -> [T] {
    return first.intersection(second)
}

/**
 Union operator
 */
public func | <T: Equatable> (first: [T], second: [T]) -> [T] {
    return first.union(second)
}

/**
 Array duplication.
 
 - parameter array: Array to duplicate
 - parameter n: How many times the array must be repeated
 - returns: Array of repeated values
 */
public func * <ItemType> (array: [ItemType], n: Int) -> [ItemType] {
    
    var result = [ItemType]()
    
    (0..<n).times {
        result += array
    }
    
    return result
}


