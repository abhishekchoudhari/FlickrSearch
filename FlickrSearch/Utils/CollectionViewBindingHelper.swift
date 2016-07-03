//
//  CollectionViewBindingHelper.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


class CollectionViewBindingHelper: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
    let nodeConstructionQueue = NSOperationQueue()
    private let collectionView: UICollectionView
    private let selectionCommand: RACCommand?
    var data: [AnyObject]
    
    //MARK: Public API
    
    init(collectionView: UICollectionView, sourceSignal: RACSignal, selectionCommand: RACCommand? = nil) {
        self.collectionView = collectionView
        self.data = []
        self.selectionCommand = selectionCommand
        
        super.init()
        
        sourceSignal.subscribeNext {
            (d:AnyObject!) -> () in
            if let object = d as? [AnyObject] {
                self.data = object
            }
            
            self.collectionView.reloadData()
        }
        
        collectionView.dataSource = self
        //    collectionView.delegate = self
    }
    
    func searchResultsFestched(results:AnyObject!){
        if let object = results as? [AnyObject] {
            self.data = object
        }
        self.collectionView.reloadData()
    }
    
    //MARK: Private
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item: AnyObject = data[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
        cell.configureCellDisplayWithCardInfo(item, nodeConstructionQueue: nodeConstructionQueue)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if selectionCommand != nil {
            selectionCommand?.execute(data[indexPath.row])
        }
    }
}
