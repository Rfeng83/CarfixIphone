//
//  BaseAPIResponse.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class BaseAPIResponse: NSObject
{
    public required init(json: Any)
    {
        super.init()
        InitializeProperties(source: json)
    }
}

class BaseAPIItem: NSObject
{
    public required init(obj: NSObject?){
        super.init()
        
        if let obj = obj as? [String: AnyObject]
        {
            InitializeProperties(source: obj)
        }
    }
}
