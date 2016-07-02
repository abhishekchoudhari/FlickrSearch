//
//  GradientNode.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class GradientNode: ASDisplayNode {
  override class func drawRect(bounds: CGRect, withParameters parameters: NSObjectProtocol!,
    isCancelled isCancelledBlock: asdisplaynode_iscancelled_block_t, isRasterizing: Bool) {
      let myContext = UIGraphicsGetCurrentContext()
      CGContextSaveGState(myContext)
      CGContextClipToRect(myContext, bounds)
      
      let componentCount: Int = 2
      let locations: [CGFloat] = [0.0, 1.0]
      let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0,
        0.0, 0.0, 0.0, 0.0]
      let myColorSpace = CGColorSpaceCreateDeviceRGB()
      let myGradient = CGGradientCreateWithColorComponents(myColorSpace, components,
        locations, componentCount)
      
      let myStartPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
      let myEndPoint = CGPoint(x: bounds.midX, y: bounds.midY)
      CGContextDrawLinearGradient(myContext, myGradient, myStartPoint,
        myEndPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
      
      CGContextRestoreGState(myContext)
    
  }
}
