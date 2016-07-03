//
//  Extensions.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    class func attributedStringForTitleText(text: String) -> NSAttributedString {
        let titleAttributes =
            [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 18)!,
             NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSShadowAttributeName: NSShadow.titleTextShadow(),
             NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        return NSAttributedString(string: text, attributes: titleAttributes)
    }
    
    class func attributedStringForCellTitleText(text: String) -> NSAttributedString {
        let titleAttributes =
            [NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 14)!,
             NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSShadowAttributeName: NSShadow.titleTextShadow(),
             NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        return NSAttributedString(string: text, attributes: titleAttributes)
    }
    
    class func attributedStringForDescriptionText(text: String) -> NSAttributedString {
        let descriptionAttributes =
            [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16)!,
             NSShadowAttributeName: NSShadow.descriptionTextShadow(),
             NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSBackgroundColorAttributeName: UIColor.clearColor(),
             NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        return NSAttributedString(string: text, attributes: descriptionAttributes)
    }
}

extension NSParagraphStyle {
    class func justifiedParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}

extension NSShadow {
    class func titleTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }
    
    class func descriptionTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }
}
