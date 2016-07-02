//
//  RACObserve.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import ReactiveCocoa

func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
  return target.rac_valuesForKeyPath(keyPath, observer: target)
}