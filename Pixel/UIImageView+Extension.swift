//
//  UIImageView+Extension.swift
//  Pixel
//
//  Created by SongFei on 15/12/5.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    private func URLEncoded(string URLString: String) -> NSURL? {
        guard let URLEncodingString = URLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {return nil}
        
        return NSURL(string: URLEncodingString)
    }

    func kfe_setImageWithURLString(URLString: String?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func kfe_setImageWithURLString(URLString: String?, completionHandler: CompletionHandler?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: completionHandler)
    }
    
    func kfe_setImageWithURLString(URLString: String?, placeholderImage: UIImage?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString, placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func kfe_setImageWithURLString(URLString: String?, placeholderImage: UIImage?, optionsInfo: KingfisherOptionsInfo?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: nil, completionHandler: nil)
    }
    
    func kfe_setImageWithURLString(URLString: String?, placeholderImage: UIImage?, optionsInfo: KingfisherOptionsInfo?, completionHandler: CompletionHandler?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: nil, completionHandler: completionHandler)
    }
    
    func kfe_setImageWithURLString(URLString: String?,
        placeholderImage: UIImage?,
        optionsInfo: KingfisherOptionsInfo?,
        progressBlock: DownloadProgressBlock?,
        completionHandler: CompletionHandler?) -> RetrieveImageTask? {
            guard let URLString = URLString, URL = NSURL(string: URLString) ?? URLEncoded(string: URLString) else {
                print("URL error")
                return nil
            }
            
            guard let image = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString) else {
                
                let defaultOptions: KingfisherOptionsInfo = [
                    .Options([.BackgroundDecode, .LowPriority]),
                    .Transition(ImageTransition.Fade(0.55))
                ]
                
                return kf_setImageWithURL(URL, placeholderImage: placeholderImage, optionsInfo: optionsInfo ?? defaultOptions, progressBlock: progressBlock, completionHandler: completionHandler)
            }
            self.image = image
            return nil
    }
    

    
    
}
