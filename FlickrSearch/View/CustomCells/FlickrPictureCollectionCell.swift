//
//  FlickrPictureCollectionCell.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class FlickrPictureCollectionCell: UICollectionViewCell, ASNetworkImageNodeDelegate {
    var featureImageSizeOptional: CGSize?
    var placeholderLayer: CALayer!
    var contentLayer: CALayer?
    var containerNode: ASDisplayNode?
    var nodeConstructionOperation: NSOperation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeholderLayer = CALayer()
        placeholderLayer.contents = UIImage(named: "cardPlaceholder")!.CGImage
        placeholderLayer.contentsGravity = kCAGravityCenter
        placeholderLayer.contentsScale = UIScreen.mainScreen().scale
        placeholderLayer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1).CGColor
        contentView.layer.addSublayer(placeholderLayer)
    }
    
    //MARK: Layout
    override func sizeThatFits(size: CGSize) -> CGSize {
        if let featureImageSize = featureImageSizeOptional {
            return FrameCalculator.sizeThatFits(size, withImageSize: featureImageSize)
        } else {
            return CGSizeZero
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        placeholderLayer?.frame = bounds
        CATransaction.commit()
    }
    
    //MARK: Cell Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let operation = nodeConstructionOperation {
            operation.cancel()
        }
        
        containerNode?.recursivelySetDisplaySuspended(true)
        contentLayer?.removeFromSuperlayer()
        contentLayer = nil
        containerNode = nil
    }
    
    func configureCellDisplayWithCardInfo(
        cardInfo: AnyObject,
        nodeConstructionQueue: NSOperationQueue) {
        if let oldNodeConstructionOperation = nodeConstructionOperation {
            oldNodeConstructionOperation.cancel()
        }
        let searhResultItem = cardInfo as! SearchResultsItemViewModel
        let newNodeConstructionOperation = nodeConstructionOperationWithCardInfo(searhResultItem)
        nodeConstructionOperation = newNodeConstructionOperation
        nodeConstructionQueue.addOperation(newNodeConstructionOperation)
    }
    
    func nodeConstructionOperationWithCardInfo(cardInfo: SearchResultsItemViewModel) -> NSOperation {
        let nodeConstructionOperation = NSBlockOperation()
        nodeConstructionOperation.addExecutionBlock {
            [weak self, unowned nodeConstructionOperation] in
            if nodeConstructionOperation.cancelled {
                return
            }
            if let strongSelf = self {
                //MARK: Node Creation Section
                
                
                //MARK: Container Node Creation Section
                let containerNode = ASDisplayNode()//(layerBlock: AnimatedContentsDisplayLayer.self)
                containerNode.layerBacked = true
                containerNode.shouldRasterizeDescendants = true
                containerNode.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
                containerNode.borderWidth = 1
                let featureImageNode = ASNetworkImageNode()
                featureImageNode.layerBacked = true
                featureImageNode.contentMode = .ScaleAspectFit
                featureImageNode.URL = cardInfo.url
                
                let titleTextNode = ASTextNode()
                titleTextNode.layerBacked = true
                titleTextNode.backgroundColor = UIColor.clearColor()
                titleTextNode.attributedString = NSAttributedString.attributedStringForTitleText(cardInfo.title)
                
                let gradientNode = GradientNode()
                gradientNode.opaque = false
                gradientNode.layerBacked = true
                
                //MARK: Node Hierarchy Section
                containerNode.addSubnode(featureImageNode)
                containerNode.addSubnode(gradientNode)
                containerNode.addSubnode(titleTextNode)
                
                //MARK: Node Layout Section
                containerNode.frame = FrameCalculator.frameForContainer(featureImageSize: CGSize(width: 150.0, height: 75.0))
                featureImageNode.frame = FrameCalculator.frameForFeatureImage(
                    featureImageSize: CGSize(width: 150.0, height: 75.0),
                    containerFrameWidth: containerNode.frame.size.width)
                titleTextNode.frame = FrameCalculator.frameForTitleText(
                    containerBounds: containerNode.bounds,
                    featureImageFrame: featureImageNode.frame)
                gradientNode.frame = FrameCalculator.frameForGradient(
                    featureImageFrame: featureImageNode.frame)
                
                dispatch_async(dispatch_get_main_queue()) { [weak nodeConstructionOperation] in
                    if let strongNodeConstructionOperation = nodeConstructionOperation {
                        if strongNodeConstructionOperation.cancelled {
                            return
                        }
                        if strongSelf.nodeConstructionOperation !== strongNodeConstructionOperation {
                            return
                        }
                        if containerNode.displaySuspended {
                            return
                        }
                        //MARK: Node Layer and Wrap Up Section
                        strongSelf.contentView.layer.addSublayer(containerNode.layer)
                        containerNode.setNeedsDisplay()
                        strongSelf.contentLayer = containerNode.layer
                        strongSelf.containerNode = containerNode
                    }
                }
            }
        }
        return nodeConstructionOperation
    }
    
    func setParallax(value: CGFloat) {
//        imageThumbnailView.transform = CGAffineTransformMakeTranslation(0, value)
    }
    
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage){
        featureImageSizeOptional = image.size
        
    }
}
