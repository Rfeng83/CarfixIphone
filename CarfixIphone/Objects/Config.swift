//
//  Config.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static var appName: String {
        get {
            if let title = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
                return title
            } else {
                return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            }
        }
    }
    static let margin: CGFloat = 4
    static let padding: CGFloat = 8
    static var lineHeight: CGFloat {
        get {
            return font.lineHeight
        }
    }
    static var boxSize: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 18
            case .iphone6plus:
                return 20
            default:
                return 16
            }
        }
    }
    static var fieldLabelWidth: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 70
            case .iphone6plus:
                return 80
            default:
                return 60
            }
        }
    }
    static var fieldLongLabelWidth: CGFloat {
        get {
            return fieldLabelWidth + 30
        }
    }
    static var fieldExtraLongLabelWidth: CGFloat {
        get {
            return fieldLongLabelWidth + 20
        }
    }
    static var fieldHeight: CGFloat {
        get {
            return buttonHeight
        }
    }
    static var iconSize: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 18
            case .iphone6plus:
                return 20
            default:
                return 16
            }
        }
    }
    static var iconSizeBig: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 28
            case .iphone6plus:
                return 32
            default:
                return 24
            }
        }
    }
    static var buttonHeight: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 36
            case .iphone6plus:
                return 40
            default:
                return 30
            }
        }
    }
    
    static let buttonFont: UIFont = UIFont.systemFont(ofSize: buttonFontSize)
    static var buttonFontSize: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 18
            case .iphone6plus:
                return 20
            default:
                return 16
            }
        }
    }
    
    static let fontSmall: UIFont = UIFont.systemFont(ofSize: fontSizeSmall)
    static var fontSizeSmall: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 12
            case .iphone6plus:
                return 14
            default:
                return 10
            }
        }
    }
    
    static let font: UIFont = UIFont.systemFont(ofSize: fontSize)
    static var fontSize: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 14
            case .iphone6plus:
                return 16
            default:
                return 12
            }
        }
    }
    
    static let fontBig: UIFont = UIFont.systemFont(ofSize: fontSizeBig)
    static var fontSizeBig: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 16
            case .iphone6plus:
                return 18
            default:
                return 14
            }
        }
    }
    
    static let fontExtraBig: UIFont = UIFont.systemFont(ofSize: fontSizeExtraBig)
    static var fontSizeExtraBig: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 20
            case .iphone6plus:
                return 22
            default:
                return 18
            }
        }
    }
    
    static var editFontSize: CGFloat {
        get {
            switch DisplayManager.typeIsLike {
            case .iphone6:
                return 15
            case .iphone6plus:
                return 17
            default:
                return 13
            }
        }
    }
    static let editFont: UIFont = UIFont.systemFont(ofSize: editFontSize)
    static let profileImageWidth: CGFloat = 500
}
