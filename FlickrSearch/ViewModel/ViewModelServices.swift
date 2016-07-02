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
  
  // pushes the given ViewModel onto the stack, this causes the UI to navigate from
  // one view to the next
  func pushViewModel(viewModel:AnyObject)
  
  // provides the search API 
  var flickrSearchService: FlickrSearch { get }
  
}