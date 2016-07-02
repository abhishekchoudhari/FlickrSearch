//
//  AnimatedContentsDisplayLayer.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnimatedContentsDisplayLayer: _ASDisplayLayer {
  override func actionForKey(event: String) -> CAAction? {
    if let action = super.actionForKey(event) {
      return action
    }
    
    if event == "contents" && contents == nil {
      let transition = CATransition()
      transition.duration = 0.6
      transition.type = kCATransitionFade
      return transition
    }
    
    return nil
  }
}
