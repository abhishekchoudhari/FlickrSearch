//
//  FlickrViewController.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 02/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit

class FlickrViewController: UIViewController, UICollectionViewDelegate, FlickrSearchViewModelProtocol {
    let nodeConstructionQueue = NSOperationQueue()
    let transition = PopAnimator()
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchCollectionView: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private var searchViewModel: FlickrSearchViewModel!
    private var bindingHelper: CollectionViewBindingHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewModelServices = ViewModelServicesImpl(navigationController: navigationController!)
        
        searchViewModel = FlickrSearchViewModel(services: viewModelServices)
        title = searchViewModel.title
        searchTextField.rac_textSignal() ~> RAC(searchViewModel, "searchText")
        searchViewModel.executeSearch!.executing.not() ~> RAC(loadingIndicator, "hidden")
        searchViewModel.executeSearch!.executing ~> RAC(UIApplication.sharedApplication(), "networkActivityIndicatorVisible")
        searchButton.rac_command = searchViewModel.executeSearch
        bindingHelper = CollectionViewBindingHelper(collectionView: searchCollectionView,
                                                    sourceSignal: RACObserve(searchViewModel, keyPath: "searchResults"))
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
        searchViewModel.delegate = self
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let searhResultItem =  bindingHelper.data[indexPath.row] as! SearchResultsItemViewModel
        performSegueWithIdentifier("presentImageDetails", sender: searhResultItem)
        //present details view controller
//        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("FlickrImageDetailsViewController") as! FlickrImageDetailsViewController
//        destinationVC.imageObject = searhResultItem
//        destinationVC.transitioningDelegate = self
//        presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentImageDetails" {
            if let destinationVC = segue.destinationViewController as? FlickrImageDetailsViewController {
                destinationVC.imageObject = sender as? SearchResultsItemViewModel
                
            }
        }
        
    }
    
    func searchResultsFetched(results:AnyObject){
        bindingHelper.searchResultsFestched(results)
    }

}

//extension FlickrViewController: UIViewControllerTransitioningDelegate {
//    func animationControllerForPresentedController(
//        presented: UIViewController,
//        presentingController presenting: UIViewController,
//                             sourceController source: UIViewController) ->
//        UIViewControllerAnimatedTransitioning? {
//            
//            transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
//            transition.presenting = true
//            
//            return transition
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.presenting = false
//        return transition
//    }
//}
