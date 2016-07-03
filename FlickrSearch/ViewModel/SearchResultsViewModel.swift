//
//  SearchResultsViewModel.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

// A ViewModel that exposes the results of a Flickr search
class SearchResultsViewModel: NSObject {
  
  var searchResults: [SearchResultsItemViewModel]
  
  
  private let services: ViewModelServices
  
  init(services: ViewModelServices, searchResults: FlickrSearchResults) {
    self.services = services
    self.searchResults = searchResults.photos.map { SearchResultsItemViewModel(photo: $0, services: services ) }
    
    super.init()
  }
}