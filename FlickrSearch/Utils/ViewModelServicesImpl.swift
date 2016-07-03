//
//  ViewModelServicesImpl.swift
//
//  GradientNode.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation

class ViewModelServicesImpl: ViewModelServices {
    private let navigationController: UINavigationController
    let flickrSearchService: FlickrSearch
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.flickrSearchService = FlickrSearchImpl()
    }
  
}