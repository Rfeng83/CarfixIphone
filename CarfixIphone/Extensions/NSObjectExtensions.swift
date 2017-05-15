import UIKit

public extension NSObject {
    func InitializeProperties(source: Any){
        let mirror = Mirror(reflecting: self)
        let children = mirror.getAllChildren()
        
        var sourceChildren: OrderedDictionary<String, Any>
        if source is NSDictionary {
            sourceChildren = OrderedDictionary<String, Any>()
            for child in (source as! NSDictionary) {
                _ = sourceChildren.insert(value: child.value, forKey: child.key as! String)
            }
        }
        else {
            let sourceMirror = Mirror(reflecting: source)
            sourceChildren = sourceMirror.getAllChildren()
        }
        
        for i in children
        {
            let child = children[i]
            let keyName: String = child.0
            if let sourceChild = sourceChildren[keyName]
            {
                let value = sourceChild
                let fieldValue = child.1
                var itemType: Any.Type
                if let optional = fieldValue as? OptionalProtocol {
                    itemType = optional.wrappedType()
                }
                else {
                    itemType = type(of: fieldValue)
                }
                
                var isArray: Bool
                if let array = itemType as? ArrayProtocol.Type {
                    itemType = array.elementType()
                    isArray = true
                }
                else {
                    isArray = false
                }
                
                if (itemType is BaseAPIItem.Type)
                {
                    let basicAPIItem: BaseAPIItem.Type = itemType as! BaseAPIItem.Type
                    
                    if isArray {
                        let list: NSMutableArray = NSMutableArray()
                        if let array = value as? NSArray {
                            var count = 0
                            for element in array {
                                list.insert(basicAPIItem.init(obj: element as? NSObject), at: count)
                                count += 1
                            }
                        }
                        self.setValue(list, forKey: keyName)
                    }
                    else {
                        let obj: BaseAPIItem? = basicAPIItem.init(obj: value as? NSObject)
                        self.setValue(obj, forKey: keyName)
                    }
                }
                else if (itemType is Date.Type)
                {
                    if value is String
                    {
                        if let date: Date = Convert(value).to() {
                            self.setValue(date, forKey: keyName)
                        }
                    }
                }
                else if (itemType is NSDate.Type)
                {
                    if value is String
                    {
                        if let date: NSDate = Convert(value).to() {
                            self.setValue(date, forKey: keyName)
                        }
                    }
                }
                else if let convertValue = Convert(value).to(itemType)
                {
                    self.setValue(convertValue, forKey: keyName)
                }
            }
        }
    }
}
