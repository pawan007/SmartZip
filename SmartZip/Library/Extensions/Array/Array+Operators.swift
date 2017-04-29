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



