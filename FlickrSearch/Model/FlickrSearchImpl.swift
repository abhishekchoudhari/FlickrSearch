//
//  FlickrSearchImpl.swift
//  FlickrSearch
//
//  Created by Abhishek's Macbook on 01/07/2016.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import Foundation
import ReactiveCocoa
import objectiveflickr

// An implementation of the FlickrSearch protocol
class FlickrSearchImpl : NSObject, FlickrSearch, OFFlickrAPIRequestDelegate {
    
    //MARK: Properties
    
    private let requests: NSMutableSet
    private let flickrContext: OFFlickrAPIContext
    private var flickrRequest: OFFlickrAPIRequest?
    
    //MARK: Public API
    
    override init() {
        let flickrAPIKey = "3b4497b8b2a9b70ee47a54b8eae6d079";
        let flickrAPISharedSecret = "3526fea9e1622e0c";
        flickrContext = OFFlickrAPIContext(APIKey: flickrAPIKey, sharedSecret:flickrAPISharedSecret)
        
        requests = NSMutableSet()
        
        flickrRequest = nil
    }
    
    // searches Flickr for the given string, returning a signal that emits the response
    func flickrSearchSignal(searchString: String) -> RACSignal {
        
        func photosFromDictionary (response: NSDictionary) -> FlickrSearchResults {
            let photoArray = response.valueForKeyPath("photos.photo") as! [[String: String]]
            let photos = photoArray.map {
                (photoDict) -> FlickrPhoto in
                let url = self.flickrContext.photoSourceURLFromDictionary(photoDict, size: OFFlickrSmallSize)
                let bigURL = self.flickrContext.photoSourceURLFromDictionary(photoDict, size: OFFlickrLargeSize)
                return FlickrPhoto(title: photoDict["title"]!, url: url, identifier: photoDict["id"]!, bigURL:bigURL)
            }
            let total = response.valueForKeyPath("photos.total")!.integerValue
            return FlickrSearchResults(searchString: searchString, totalResults: total, photos: photos)
        }
        
        return signalFromAPIMethod("flickr.photos.search",
                                   arguments: ["text" : searchString, "sort": "interestingness-desc"],
                                   transform: photosFromDictionary);
    }
    
    // searches Flickr for the given photo metadata, returning a signal that emits the response
    func flickrImageMetadata(photoId: String) -> RACSignal {
        
        let favouritesSignal = signalFromAPIMethod("flickr.photos.getFavorites",
                                                   arguments: ["photo_id": photoId]) {
                                                    // String is not AnyObject?
                                                    (response: NSDictionary) -> NSString in
                                                    return response.valueForKeyPath("photo.total") as! NSString
        }
        
        let commentsSignal = signalFromAPIMethod("flickr.photos.getInfo",
                                                 arguments: ["photo_id": photoId]) {
                                                    (response: NSDictionary) -> NSString in
                                                    return response.valueForKeyPath("photo.comments._text") as! NSString
        }
        
        let getInfoSignal = signalFromAPIMethod("flickr.photos.getInfo",arguments: ["photo_id": photoId]) {
            (response: NSDictionary) -> NSString in
            if let temp = response.valueForKeyPath("photo.description._text"){
                return temp as! NSString
            }
            return "No description"
        }
        
        return RACSignalEx.combineLatestAs([favouritesSignal, commentsSignal, getInfoSignal]) {
            (favourites:NSString, comments:NSString, imageDescription: NSString) -> FlickrPhotoMetadata in
            return FlickrPhotoMetadata(favourites: favourites.integerValue, comments: comments.integerValue, imageDescription: imageDescription)
        }
    }
    
    //MARK: Private
    
    // a utility method that searches Flickr with the given method and arguments. The response
    // is transformed via the given function.
    private func signalFromAPIMethod<T: AnyObject>(method: String, arguments: [String:String],
                                     transform: (NSDictionary) -> T) -> RACSignal {
        
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let flickrRequest = OFFlickrAPIRequest(APIContext: self.flickrContext);
            flickrRequest.delegate = self;
            self.requests.addObject(flickrRequest)
            
            let sucessSignal = self.rac_signalForSelector(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didCompleteWithResponse:)),
                fromProtocol: OFFlickrAPIRequestDelegate.self)
            
            sucessSignal
                // filter to only include responses from this request
                .filterAs { (tuple: RACTuple) -> Bool in tuple.first as! NSObject == flickrRequest }
                // extract the second tuple argument, which is the response dictionary
                .mapAs { (tuple: RACTuple) -> AnyObject in tuple.second }
                // transform with the given function
                .mapAs(transform)
                // subscribe, sending the results to the outer signal
                .subscribeNext {
                    (next: AnyObject!) -> () in
                    subscriber.sendNext(next)
                    subscriber.sendCompleted()
            }
            
            
            let failSignal = self.rac_signalForSelector(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didFailWithError:)),
                fromProtocol: OFFlickrAPIRequestDelegate.self)
            
            failSignal.mapAs { (tuple: RACTuple) -> AnyObject in tuple.second }
                .subscribeNextAs {
                    (error: NSError) -> () in
                    print("error: \(error)")
                    subscriber.sendError(error)
            }
            
            flickrRequest.callAPIMethodWithGET(method, arguments: arguments)
            
            return RACDisposable(block: {
                self.requests.removeObject(flickrRequest)
            })
        })
        
    }
}
