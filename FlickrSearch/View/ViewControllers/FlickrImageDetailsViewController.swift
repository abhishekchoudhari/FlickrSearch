//
//  FlickrImageDetailsViewController.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 03/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit
import SDWebImage

class FlickrImageDetailsViewController: UIViewController {
    var imageObject: SearchResultsItemViewModel? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = NSAttributedString.attributedStringForTitleText(imageObject!.title)
        mainImageView.sd_setImageWithURL(imageObject!.bigURL, placeholderImage:UIImage(named:"cardPlaceHolder"))
        
        self.favoritesLabel.text = Int((imageObject?.favourites)!) == -1 ? "" : "\(Int((imageObject?.favourites)!))"
        self.commentsLabel.text = Int(imageObject!.comments) == -1 ? "" : "\(imageObject!.comments)"
        self.descriptionLabel.attributedText = NSAttributedString.attributedStringForDescriptionText(imageObject!.imageDescription)
    }
    @IBAction func backBtnClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
}
