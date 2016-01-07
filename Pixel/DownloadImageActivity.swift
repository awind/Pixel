//
//  DownloadImageActivity.swift
//  Pixel
//
//  Created by SongFei on 15/12/29.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import SDWebImage

class DownloadImageActivity: UIActivity {
    
    var urlToShare: String?
    
    override func activityType() -> String? {
        return "Actions.Download"
    }
    
    override func activityTitle() -> String? {
        return "Save Image"
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        NSLog("%@", __FUNCTION__)
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        self.urlToShare = activityItems.first as! String
        NSLog("%@", __FUNCTION__)
    }
    
    override func activityViewController() -> UIViewController? {
        NSLog("%@", __FUNCTION__)
        return nil
    }
    
    override func performActivity() {
        // Todo: handle action:
        NSLog("%@", __FUNCTION__)
        
        let sdWebImageManager = SDWebImageManager.sharedManager()
        sdWebImageManager.downloadImageWithURL(NSURL(string: self.urlToShare!),
            options: .LowPriority,
            progress: { (receiveSize, expectSize) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            },
            completed: {[weak self] (image, error, cached, finished, url) in
                if let _ = self {
                    dispatch_async(dispatch_get_main_queue(), {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        NSLog("success")
                    })
                }
            })

        
        
        self.activityDidFinish(true)
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "ic_like")
    }
}
