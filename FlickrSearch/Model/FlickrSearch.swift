//
//  FlickrSearch.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import ReactiveCocoa


// Provides an API for searching Flickr
protocol FlickrSearch {
  
  // searches Flickr for the given string, returning a signal that emits the response
  func flickrSearchSignal(searchString: String) -> RACSignal
  
  // searches Flickr for the given photo metadata, returning a signal that emits the response
  func flickrImageMetadata(photoId: String) -> RACSignal
}