//
//  FlickrPhotoMetadata.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// Represents the metadata relating to a single photo
class FlickrPhotoMetadata {
  let favourites: Int
  let comments: Int
  
  init(favourites:Int?, comments: Int?) {
    self.favourites = favourites != nil ? favourites! : 0
    self.comments = comments != nil ? comments! : 0
  }
}