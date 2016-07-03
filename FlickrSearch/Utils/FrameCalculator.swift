//
//  FrameCalculator.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit

class FrameCalculator {
    class var cardWidth: CGFloat {
        return 150.0
    }
    
    class func frameForTitleText(containerBounds containerBounds: CGRect, featureImageFrame: CGRect) -> CGRect {
        var frameForTitleText = CGRect(x: 0, y: featureImageFrame.maxY - 70.0, width: containerBounds.width, height: 80)
        frameForTitleText.insetInPlace(dx: 20, dy: 20)
        return frameForTitleText
    }
    
    class func frameForGradient(featureImageFrame featureImageFrame: CGRect) -> CGRect {
        return featureImageFrame
    }
    
    class func frameForFeatureImage(featureImageSize featureImageSize: CGSize, containerFrameWidth: CGFloat) -> CGRect {
        let imageFrameSize = aspectSizeForWidth(containerFrameWidth, originalSize: featureImageSize)
        return CGRect(x: 0, y: 0, width: imageFrameSize.width, height: imageFrameSize.height)
    }
    
    class func frameForBackgroundImage(containerBounds containerBounds: CGRect) -> CGRect {
        return containerBounds
    }
    
    class func frameForContainer(featureImageSize featureImageSize: CGSize) -> CGRect {
        let containerWidth: CGFloat = cardWidth
        let size = sizeThatFits(CGSizeMake(containerWidth, CGFloat.max), withImageSize: featureImageSize)
        return CGRect(x: 0, y: 0, width: containerWidth, height: size.height)
    }
    
    class func sizeThatFits(size: CGSize, withImageSize imageSize: CGSize) -> CGSize {
        let imageFrameSize = aspectSizeForWidth(size.width, originalSize: imageSize)
        return CGSize(width: size.width, height: imageFrameSize.height)
    }
    
    class func aspectSizeForWidth(width: CGFloat, originalSize: CGSize) -> CGSize {
        let height =  ceil((originalSize.height / originalSize.width) * width)
        return CGSize(width: width, height: height)
    }
    
}