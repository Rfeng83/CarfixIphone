//
//  OrderedDictionary.swift
//  Carfix2
//
//  Created by Re Foong Lim on 11/07/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

public struct OrderedDictionary<KeyType: Hashable, ValueType>: Sequence, IteratorProtocol {
    typealias ArrayType = [KeyType]
    typealias DictionaryType = [KeyType: ValueType]
    
    var array = ArrayType()
    var dictionary = DictionaryType()

    mutating func insert(value: ValueType, forKey key: KeyType, atIndex index: Int) -> ValueType?
    {
        var adjustedIndex = index
        
        let existingValue = self.dictionary[key]
        if existingValue != nil {
            let existingIndex = self.array.index(of: key)!
            
            if existingIndex < index {
                adjustedIndex -= 1
            }
            self.array.remove(at: existingIndex)
        }
        
        self.array.insert(key, at:adjustedIndex)
        self.dictionary[key] = value
        
        return existingValue
    }
    
    mutating func insert(value: ValueType, forKey key: KeyType) -> ValueType?
    {
        return insert(value: value, forKey: key, atIndex: self.count)
    }
    
    mutating func removeAtIndex(index: Int) -> (KeyType, ValueType)
    {
        precondition(index < self.array.count, "Index out-of-bounds")
        
        let key = self.array.remove(at: index)
        let value = self.dictionary.removeValue(forKey: key)!
        return (key, value)
    }
    
    var count: Int {
        return self.array.count
    }
    
    subscript(key: KeyType) -> ValueType? {
        get {
            return self.dictionary[key]
        }
        set {
            if self.array.index(of: key) != nil {
                self.array.append(key)
            }
            
            self.dictionary[key] = newValue
        }
    }
    
    subscript(index: Int) -> (KeyType, ValueType) {
        get {
            precondition(index < self.array.count,
                         "Index out-of-bounds")
            
            let key = self.array[index]
            let value = self.dictionary[key]!
            return (key, value)
        }
    }
    
    /// Creates a generator for each (key, value)
    public func generate() -> AnyIterator<(KeyType , ValueType)> {
        var index = 0
        return AnyIterator<(KeyType, ValueType)> {
            if index < self.count {
                let key = self.array[index]
                let value = self.dictionary[key]
                index = index + 1
                return (key, value!)
            } else {
                index = 0
                return nil
            }
        }
    }
    
    var sequenceCount: Int = 0
    mutating public func next() -> Int? {
        if sequenceCount == count {
            sequenceCount = 0
            return nil
        } else {
            defer { sequenceCount += 1 }
            return sequenceCount
        }
    }
}
