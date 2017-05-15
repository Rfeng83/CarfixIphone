//
//  OptionalExtension.swift
//  Carfix
//
//  Created by Re Foong Lim on 26/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

protocol ArrayProtocol {
    func elementType() -> Any.Type
    static func elementType() -> Any.Type
}

extension Array : ArrayProtocol {
    func elementType() -> Any.Type {
        return Element.self
    }
    static func elementType() -> Any.Type {
        return Element.self
    }
}
