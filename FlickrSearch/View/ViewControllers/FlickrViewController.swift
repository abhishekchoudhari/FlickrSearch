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
    
//    private let searchViewModel: FlickrSearchViewModel
//    private var bindingHelper: CollectionViewBindingHelper!
//    private let searchResultsViewModel: SearchResultsViewModel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
