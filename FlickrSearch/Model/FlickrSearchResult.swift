//
//  FlickrSearchResult.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// Represents the result of a Flickr search
class FlickrSearchResults {
  let searchString: String
  let totalResults: Int
  let photos: [FlickrPhoto]
  
  init(searchString: String, totalResults: Int, photos: [FlickrPhoto]) {
    self.searchString = searchString;
    self.totalResults = totalResults
    self.photos = photos
  }
}
