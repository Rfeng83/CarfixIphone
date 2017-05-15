//
//  StringExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 04/06/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func URLEncodedString() -> String? {
        let customAllowedSet = NSCharacterSet(charactersIn:"\"#%/<>?@\\^`{|+").inverted
        //        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString
    }
    
    func beautify() -> String {
        do {
            let regexp = try NSRegularExpression(pattern: "([a-z])([A-Z])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            
            let newString = regexp.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSMakeRange(0, self.characters.count), withTemplate: "$1 $2").capitalized
            
//            let newString = regexp.stringByReplacingMatchesInString(self, options: NSRegularExpression.MatchingOptions.WithTransparentBounds, range: NSMakeRange(0, self.characters.count), withTemplate: "$1 $2").capitalizedString
            return newString
        } catch {}
        
        return self
    }
    
    func isImagePath() -> Bool {
        let path = self.uppercased()
        return path.hasSuffix(".JPG") ||
            path.hasSuffix(".JPEG") ||
            path.hasSuffix(".BMP") ||
            path.hasSuffix(".PNG") ||
            path.hasSuffix(".GIF")
    }
    
    func addingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    func height(with constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(with constrainedHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}
