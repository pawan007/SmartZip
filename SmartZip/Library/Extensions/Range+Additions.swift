//
//  Range+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
// MARK: - Range Extension
internal extension Range {
    
    
}

/**
*  Operator == to compare 2 ranges first, second by start & end indexes. If first.startIndex is equal to
*  second.startIndex and first.endIndex is equal to second.endIndex the ranges are considered equal.
*/
public func == <U: Comparable> (first: Range<U>, second: Range<U>) -> Bool {
    return first.lowerBound == second.lowerBound &&
           first.upperBound == second.upperBound
}
