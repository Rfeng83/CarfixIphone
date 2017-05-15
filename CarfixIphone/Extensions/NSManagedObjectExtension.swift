//
//  NSManagedObjectExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 31/03/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject
{
    func stillExists() -> Bool
    {
        return self.managedObjectContext != nil
    }
}
