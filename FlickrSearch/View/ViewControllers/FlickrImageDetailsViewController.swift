//
//  FlickrImageDetailsViewController.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 03/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

class FlickrImageDetailsViewController: UIViewController {
    var imageObject: SearchResultsItemViewModel? = nil
    var backgroundImage: UIImage?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = NSAttributedString.attributedStringForTitleText(imageObject!.title)
        RACObserve(imageObject, keyPath: "favourites").subscribeNextAs {
            (faves:NSNumber) -> () in
            self.favoritesLabel.text = Int(faves) == -1 ? "" : "\(Int(faves))"
        }
        
        RACObserve(imageObject, keyPath: "comments").subscribeNextAs {
            (comments:NSNumber) -> () in
            self.commentsLabel.text = Int(comments) == -1 ? "" : "\(comments)"
        }
        
        RACObserve(imageObject, keyPath: "imageDescription").subscribeNextAs {
            (imageDescription:String) -> () in
            self.descriptionLabel.attributedText = NSAttributedString.attributedStringForDescriptionText(imageDescription)
            self.descriptionLabel.hidden = false
        }
    }
    @IBAction func backBtnClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
}
