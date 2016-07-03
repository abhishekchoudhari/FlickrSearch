//
//  ViewModelServices.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// provides common services to view models
protocol ViewModelServices {  
  // provides the search API 
  var flickrSearchService: FlickrSearch { get }
  
}