//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// represents a single photo in a Flickr search
class FlickrPhoto {

  let title :String
  let url :NSURL
  let identifier :String
  
  init (title: String, url: NSURL, identifier: String) {
    self.title = title
    self.url = url
    self.identifier = identifier
  }

}
