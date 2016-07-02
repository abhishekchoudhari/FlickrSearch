//
//  FlickrSearchViewController.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit

class FlickrSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchCollectionView: UICollectionView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchHistoryTable: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private let searchViewModel: FlickrSearchViewModel
    private var bindingHelper: CollectionViewBindingHelper!
    private let searchResultsViewModel: SearchResultsViewModel

//    required init?(coder: NSCoder) {
//        fatalError("NSCoding not supported")
//    }
    
    let flickrCardsInfo = getAllCardInfo()
    let nodeConstructionQueue = NSOperationQueue()
    
//    convenience init(searchViewModel:FlickrSearchViewModel,searchResultsViewModel:SearchResultsViewModel) {
//        super.init()
//        self.searchViewModel = searchViewModel
//        self.searchResultsViewModel = searchResultsViewModel
////        self.edgesForExtendedLayout = .None
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        title = searchViewModel.title
        
        searchTextField.rac_textSignal() ~> RAC(searchViewModel, "searchText")
        
        searchViewModel.executeSearch!.executing.not() ~> RAC(loadingIndicator, "hidden")
        
        searchViewModel.executeSearch!.executing ~> RAC(UIApplication.sharedApplication(), "networkActivityIndicatorVisible")
        
        searchButton.rac_command = searchViewModel.executeSearch
        
        bindingHelper = CollectionViewBindingHelper(collectionView: searchCollectionView, sourceSignal: RACObserve(searchResultsViewModel, keyPath: "searchResults"), nibName: "SearchResultsTableViewCell")
//        bindingHelper = TableViewBindingHelper(tableView: searchHistoryTable,
//                                               sourceSignal: RACObserve(searchViewModel, keyPath: "previousSearches"), nibName: "RecentSearchItemTableViewCell",
//                                               selectionCommand: searchViewModel.previousSearchSelected)
        
        searchViewModel.connectionErrors.subscribeNextAs {
            (error: NSError) -> () in
//            let alert = UIAlertView(title: "Connection Error", message: "There was a problem reaching Flickr", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
        }
        
        func hideKeyboard(any: AnyObject!) {
            self.searchTextField.resignFirstResponder()
        }
        searchViewModel.executeSearch!.executionSignals.subscribeNext(hideKeyboard)
        bindingHelper.delegate = self
    }
    
    func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return flickrCardsInfo.count
    }
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
        let cardInfo = flickrCardsInfo[indexPath.item]
        cell.configureCellDisplayWithCardInfo(cardInfo, nodeConstructionQueue: nodeConstructionQueue)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cells = searchCollectionView.visibleCells
        for cell in cells as! [FlickrPictureCollectionCell] {
            let value = -40.0 + (cell.frame.origin.y - searchCollectionView.contentOffset.y) / 5.0;
            cell.setParallax(value)
        }
    }

}
