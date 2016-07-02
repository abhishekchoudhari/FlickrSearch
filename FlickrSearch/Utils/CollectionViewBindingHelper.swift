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

@objc protocol ReactiveView {
  func bindViewModel(viewModel: AnyObject)
}

class CollectionViewBindingHelper: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
  
  //MARK: Properties
  
  var delegate: UICollectionViewDelegate?
  
  private let collectionView: UICollectionView
  private let templateCell: UICollectionViewCell
  private let selectionCommand: RACCommand?
  private var data: [AnyObject]

  //MARK: Public API
  
  init(collectionView: UICollectionView, sourceSignal: RACSignal, nibName: String, selectionCommand: RACCommand? = nil) {
    self.collectionView = collectionView
    self.data = []
    self.selectionCommand = selectionCommand
    
    let nib = UINib(nibName: nibName, bundle: nil)

    // create an instance of the template cell and register with the collectionView view
    templateCell = nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
    collectionView.registerNib(nib, forCellWithReuseIdentifier: templateCell.reuseIdentifier!)
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
    super.init()
    
    sourceSignal.subscribeNext {
      (d:AnyObject!) -> () in
      self.data = d as! [AnyObject]
      self.collectionView.reloadData()
    }
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  //MARK: Private
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
        //    let cardInfo = flickrCardsInfo[indexPath.item]
        //    cell.configureCellDisplayWithCardInfo(cardInfo, nodeConstructionQueue: nodeConstructionQueue)
        //    return cell
        
        
        let item: AnyObject = data[indexPath.row]
        //    let cell = collectionView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!)
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(item)
        }
        return cell
    }
    
    
  
//  func collectionView(collectionView: UICollectionView, numberOfRowsInSection section: Int) -> Int {
//    return data.count
//  }
//
//  func collectionView(collectionView: UICollectionView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    
//    
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrPictureCell", forIndexPath: indexPath) as! FlickrPictureCollectionCell
////    let cardInfo = flickrCardsInfo[indexPath.item]
////    cell.configureCellDisplayWithCardInfo(cardInfo, nodeConstructionQueue: nodeConstructionQueue)
////    return cell
//    
//    
//    let item: AnyObject = data[indexPath.row]
////    let cell = collectionView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!)
//    if let reactiveView = cell as? ReactiveView {
//      reactiveView.bindViewModel(item)
//    }
//    return cell
//  }
  
  func collectionView(collectionView: UICollectionView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return templateCell.frame.size.height
  }
  
  func collectionView(collectionView: UICollectionView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    if selectionCommand != nil {
      selectionCommand?.execute(data[indexPath.row])
    }
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if self.delegate?.respondsToSelector(#selector(UIScrollViewDelegate.scrollViewDidScroll(_:))) == true {
      self.delegate?.scrollViewDidScroll?(scrollView);
    }
  }
}
