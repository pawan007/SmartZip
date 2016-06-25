//
//  Array+Additions.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

internal extension Array {
    
    private var indexesInterval: HalfOpenInterval<Int> { return HalfOpenInterval<Int>(0, self.count) }
    
    /**
     Checks if self contains a list of items.
     
     - parameter items: Items to search for
     - returns: true if self contains all the items
     */
    func contains <T: Equatable> (items: T...) -> Bool {
        return items.all { self.indexOf($0) >= 0 }
    }
    /**
     Checks if test returns true for all the elements in self
     
     - parameter test: Function to call for each element
     - returns: True if test returns true for all the elements in self
     */
    func all (test: (Element) -> Bool) -> Bool {
        for item in self {
            if !test(item) {
                return false
            }
        }
        
        return true
    }
    
    /**
     Index of the first occurrence of item, if found.
     
     - parameter item: The item to search for
     - returns: Index of the matched item or nil
     */
    func indexOf <U: Equatable> (item: U) -> Int? {
        if item is Element {
            return unsafeBitCast(self, [U].self).indexOf(item)
        }
        
        return nil
    }
    
    /**
     Index of the first item that meets the condition.
     
     - parameter condition: A function which returns a boolean if an element satisfies a given condition or not.
     - returns: Index of the first matched item or nil
     */
    func indexOf (condition: Element -> Bool) -> Int? {
        for (index, element) in self.enumerate() {
            if condition(element) {
                return index
            }
        }
        
        return nil
    }
    
    /**
     Iterates on each element of the array.
     
     - parameter call: Function to call for each element
     */
    func each (call: (Element) -> ()) {
        
        for item in self {
            call(item)
        }
    }
    
    /**
     Costructs an array removing the duplicate values in self
     if Array.Element implements the Equatable protocol.
     
     - returns: Array of unique values
     */
    func unique <T: Equatable> () -> [T] {
        var result = [T]()
        
        for item in self {
            if !result.contains(item as! T) {
                result.append(item as! T)
            }
        }
        
        return result
    }

    /**
     Returns the number of elements which meet the condition
     
     - parameter test: Function to call for each element
     - returns: the number of elements meeting the condition
     */
    func countWhere (test: (Element) -> Bool) -> Int {
        
        var result = 0
        
        for item in self {
            if test(item) {
                result += 1
            }
        }
        
        return result
    }
    
    /**
     Randomly rearranges the elements of self using the Fisher-Yates shuffle
     */
    mutating func shuffle () {
        
        for var i = self.count - 1; i >= 1; i -= 1 {
            let j = Int.random(max: i)
            swap(&self[i], &self[j])
        }
    }
    
    /**
     Shuffles the values of the array into a new one
     
     - returns: Shuffled copy of self
     */
    func shuffled () -> Array {
        var shuffled = self
        
        shuffled.shuffle()
        
        return shuffled
    }
    
    /**
     Returns the subarray in the given range.
     
     - parameter range: Range of the subarray elements
     - returns: Subarray or nil if the index is out of bounds
     */
    subscript (rangeAsArray rangeAsArray: Range<Int>) -> Array {
        //  Fix out of bounds indexes
        let start = Swift.max(0, rangeAsArray.startIndex)
        let end = Swift.min(rangeAsArray.endIndex, count)
        
        if start > end {
            return []
        }
        
        return Array(self[Range(start: start, end: end)] as ArraySlice<Element>)
    }
    
    /**
     Returns a subarray whose items are in the given interval in self.
     
     - parameter interval: Interval of indexes of the subarray elements
     - returns: Subarray or nil if the index is out of bounds
     */
    subscript (interval: HalfOpenInterval<Int>) -> Array {
        return self[rangeAsArray: Range(start: interval.start, end: interval.end)]
    }
    
    /**
     Returns a subarray whose items are in the given interval in self.
     
     - parameter interval: Interval of indexes of the subarray elements
     - returns: Subarray or nil if the index is out of bounds
     */
    subscript (interval: ClosedInterval<Int>) -> Array {
        return self[rangeAsArray: Range(start: interval.start, end: interval.end + 1)]
    }
    
    /**
     Creates an array with the elements at indexes in the given list of integers.
     
     - parameter first: First index
     - parameter second: Second index
     - parameter rest: Rest of indexes
     - returns: Array with the items at the specified indexes
     */
    subscript (first: Int, second: Int, rest: Int...) -> Array {
        let indexes = [first, second] + rest
        return indexes.map { self[$0] }
    }
    
    /**
     Gets the objects in the specified range.
     
     - parameter range:
     - returns: Subarray in range
     */
    func get (range: Range<Int>) -> Array {
        
        return self[rangeAsArray: range]
    }
    
    /**
     Returns a random subarray of given length.
     
     - parameter n: Length
     - returns: Random subarray of length n
     */
    func sample (size n: Int = 1) -> Array {
        if n >= count {
            return self
        }
        
        let index = Int.random(max: count - n)
        return self[index..<(n + index)]
    }
    
    /**
     Max value in the current array (if Array.Element implements the Comparable protocol).
     
     - returns: Max value
     */
    func max <U: Comparable> () -> U {
        
        return map {
            return $0 as! U
            }.maxElement()!
    }
    
    /**
     Difference of self and the input arrays.
     
     - parameter values: Arrays to subtract
     - returns: Difference of self and the input arrays
     */
    func difference <T: Equatable> (values: [T]...) -> [T] {
        
        var result = [T]()
        
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //  if a value is in both self and one of the values arrays
                    //  jump to the next iteration of the outer loop
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self
                result.append(element)
            }
        }
        
        return result
    }
    
    /**
     Intersection of self and the input arrays.
     
     - parameter values: Arrays to intersect
     - returns: Array of unique values contained in all the dictionaries and self
     */
    func intersection <U: Equatable> (values: [U]...) -> Array {
        
        var result = self
        var intersection = Array()
        
        for (i, value) in values.enumerate() {
            
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if (i > 0) {
                result = intersection
                intersection = Array()
            }
            
            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.each { (item: U) -> Void in
                if result.contains(item) {
                    intersection.append(item as! Element)
                }
            }
        }
        
        return intersection
    }
    
    /**
     Union of self and the input arrays.
     
     - parameter values: Arrays
     - returns: Union array of unique values
     */
    func union <U: Equatable> (values: [U]...) -> Array {
        
        var result = self
        
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value as! Element)
                }
            }
        }
        
        return result
    }
}