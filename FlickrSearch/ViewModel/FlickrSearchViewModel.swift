//
//  FlickrSearchViewModel.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import ReactiveCocoa

protocol FlickrSearchViewModelProtocol :class{
    func searchResultsFetched(results:AnyObject)
}

class FlickrSearchViewModel: NSObject {
    
    //MARK: Properties
    
    dynamic var searchText = ""
    var executeSearch: RACCommand?
    let title = "Flickr Search"
    var previousSearchSelected: RACCommand!
    var connectionErrors: RACSignal!
    var searchResults: [SearchResultsItemViewModel]?
    weak var delegate : FlickrSearchViewModelProtocol?
    private let services: ViewModelServices
    
    //MARK: Public APIprintln
    
    init(services: ViewModelServices) {
        
        self.services = services
        super.init()
        
        let validSearchSignal = RACObserve(self, keyPath: "searchText").mapAs {
            (text: NSString) -> NSNumber in
            return text.length > 2
            }.distinctUntilChanged();
        
        executeSearch = RACCommand(enabled: validSearchSignal) {
            (any:AnyObject!) -> RACSignal in
            return self.executeSearchSignal()
        }
        connectionErrors = executeSearch!.errors
        
    }
    
    func searchResultsFunc (searchResults: FlickrSearchResults){
        self.searchResults = searchResults.photos.map { SearchResultsItemViewModel(photo: $0, services: services ) }
        delegate?.searchResultsFetched(self.searchResults!)
        
    }
    
    //MARK: Private methods
    
    private func executeSearchSignal() -> RACSignal {
        return services.flickrSearchService.flickrSearchSignal(searchText).doNextAs {
            (results: FlickrSearchResults) -> () in
            self.searchResultsFunc(results)
        }
    }
    
    
}

