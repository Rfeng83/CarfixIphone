//
//  EnumManager.swift
//  Carfix2
//
//  Created by Re Foong Lim on 06/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

class EnumManager
{
    func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
 
    func array<T: Hashable>(_: T.Type) -> [T]
    {
        var arr: [T] = []
        for i in iterateEnum(T.self)
        {
            arr.append(i)
        }
        return arr
    }
}
