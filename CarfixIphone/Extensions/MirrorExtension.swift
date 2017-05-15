//
//  MirrorExtension.swift
//  Carfix
//
//  Created by Re Foong Lim on 24/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

public extension Mirror
{
    func getAllChildren() -> OrderedDictionary<String, Any> {
        var allChildren: OrderedDictionary<String, Any> = OrderedDictionary<String, Any>()
        
        let superMirror = self.superclassMirror
        if(superMirror != nil)
        {
            let superChildren = superMirror!.getAllChildren()
            for i in 0..<superChildren.count {
                let child = superChildren[i]
                _ = allChildren.insert(value: child.1, forKey: child.0)
            }
        }
        
        for child in self.children
        {
            _ = allChildren.insert(value: child.value, forKey: child.label!)
        }
        
        return allChildren
    }
    
    
}
