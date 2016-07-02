//
//  FlickrViewController.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit

class FlickrViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    let rainforestCardsInfo = getAllCardInfo()
    let nodeConstructionQueue = NSOperationQueue()
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchCollectionView: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private let searchViewModel: FlickrSearchViewModel
    private var bindingHelper: CollectionViewBindingHelper!
    private let searchResultsViewModel: SearchResultsViewModel
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        
//        
//        
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(flickrSearchViewModel:FlickrSearchViewModel, searchResultsViewModel:SearchResultsViewModel) {
        self.searchViewModel = flickrSearchViewModel
        self.searchResultsViewModel = searchResultsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
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
        
        bindingHelper = CollectionViewBindingHelper(collectionView: searchCollectionView,
                                               sourceSignal: RACObserve(searchViewModel, keyPath: "previousSearches"), nibName: "RecentSearchItemTableViewCell",
                                               selectionCommand: searchViewModel.previousSearchSelected)
        
        searchViewModel.connectionErrors.subscribeNextAs {
            (error: NSError) -> () in
            
            let alertController = UIAlertController(title: "Connection Error", message: "There was a problem reaching Flickr", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: { 
                    
                })
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                
            }
        }
        
        func hideKeyboard(any: AnyObject!) {
            self.searchTextField.resignFirstResponder()
        }
        searchViewModel.executeSearch!.executionSignals.subscribeNext(hideKeyboard)
    }
    
    func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return rainforestCardsInfo.count
    }
    
    func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
        let cardInfo = rainforestCardsInfo[indexPath.item]
        cell.configureCellDisplayWithCardInfo(cardInfo, nodeConstructionQueue: nodeConstructionQueue)
        return cell
    }
}
