//
//  PreviousSearchViewModel.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// Represents a search that was executed previously
class PreviousSearchViewModel: NSObject {

  let searchString: String
  let totalResults: Int
  let thumbnail: NSURL
  
  init(searchString: String, totalResults: Int, thumbnail: NSURL) {
    self.searchString = searchString
    self.totalResults = totalResults
    self.thumbnail = thumbnail
  }
}