//
//  GradientView.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class GradientView: UIView {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clearColor()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clearColor()
  }
  
  convenience init() {
    self.init(frame: CGRectZero)
  }
  
  override func drawRect(rect: CGRect) {
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
