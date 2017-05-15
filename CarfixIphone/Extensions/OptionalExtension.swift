//
//  OptionalExtension.swift
//  Carfix
//
//  Created by Re Foong Lim on 26/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

protocol OptionalProtocol {
    func wrappedType() -> Any.Type
    static func wrappedType() -> Any.Type
    var value: Any { get }
    var isEmpty: Bool { get }
}

extension Optional : OptionalProtocol {
    func wrappedType() -> Any.Type {
        return Wrapped.self
    }
    static func wrappedType() -> Any.Type {
        return Wrapped.self
    }
    var value: Any {
        get{
            return self!
        }
    }
    var isEmpty: Bool {
        get{
            return self == nil || "\(self.value)" == ""
        }
    }
    var hasValue: Bool {
        get {
            return !isEmpty
        }
    }
}
