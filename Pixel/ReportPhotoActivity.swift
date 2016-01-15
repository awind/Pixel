//
//  ReportPhotoActivity.swift
//  Pixel
//
//  Created by SongFei on 16/1/15.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ReportPhotoActivity: UIActivity {
    var photoId: Int?
    var viewcontroller: UIViewController?
    var view: UIView?
    
    let OFFENSIVE = 1
    let SPAM = 2
    let OFFTOPIC = 3
    let COPYRIGHT = 4
    let WRONGCONTENT = 5
    let ADULTCONTENT = 6
    let OTHER = 0
    
    override func activityType() -> String? {
        return "Actions.Report"
    }
    
    override func activityTitle() -> String? {
        return NSLocalizedString("REPORT", comment: "report")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        NSLog("%@", __FUNCTION__)
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        NSLog("%@", __FUNCTION__)
    }
    
    override func activityViewController() -> UIViewController? {
        NSLog("%@", __FUNCTION__)
        return nil
    }
    
    override func performActivity() {
        // Todo: handle action:
        NSLog("%@", __FUNCTION__)
        
        let alertController = UIAlertController(title: "", message: NSLocalizedString("REPORT_ALERT_MESSAGE", comment: "reportMessage"), preferredStyle: .ActionSheet)
        
        let offensiveAction = UIAlertAction(title: NSLocalizedString("OFFENSIVE", comment: "offensive"), style: UIAlertActionStyle.Default) { action in
            let hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Loading..."
            hud.show(true)
            Alamofire.request(Router.Report(self.photoId!, self.OFFENSIVE, ""))
                .responseSwiftyJSON() { response in
                    Logger.printLog(response)
                    hud.mode = MBProgressHUDMode.CustomView
                    hud.customView = UIImageView(image: UIImage(named: "ic_checkmark"))
                    hud.labelText = "Success"
                    hud.hide(true, afterDelay: 1)
            }
        }
        
        let spamAction = UIAlertAction(title: NSLocalizedString("SPAM", comment: "spam"), style: UIAlertActionStyle.Default) { action in
            let hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Loading..."
            hud.show(true)
            Alamofire.request(Router.Report(self.photoId!, self.SPAM, ""))
                .responseSwiftyJSON() { response in
                    Logger.printLog(response)
                    hud.mode = MBProgressHUDMode.CustomView
                    hud.customView = UIImageView(image: UIImage(named: "ic_checkmark"))
                    hud.labelText = "Success"
                    hud.hide(true, afterDelay: 1)
            }
        }
        
        let offTopicAction = UIAlertAction(title: "Offtopic", style: UIAlertActionStyle.Default) { action in
            
        }
        
        let copyrightAction = UIAlertAction(title: NSLocalizedString("COPYRIGHT", comment: "COPYRIGHT"), style: UIAlertActionStyle.Default) { action in
            let hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Loading..."
            hud.show(true)
            Alamofire.request(Router.Report(self.photoId!, self.COPYRIGHT, ""))
                .responseSwiftyJSON() { response in
                    Logger.printLog(response)
                    hud.mode = MBProgressHUDMode.CustomView
                    hud.customView = UIImageView(image: UIImage(named: "ic_checkmark"))
                    hud.labelText = "Success"
                    hud.hide(true, afterDelay: 1)
            }
        }
        
        let wronContentAction = UIAlertAction(title: "Wrong content", style: UIAlertActionStyle.Default) { action in
            
        }
        
        let adultAction = UIAlertAction(title: NSLocalizedString("ADULTCONTENT", comment: "adult"), style: UIAlertActionStyle.Default) { action in
            let hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Loading..."
            hud.show(true)
            Alamofire.request(Router.Report(self.photoId!, self.ADULTCONTENT, ""))
                .responseSwiftyJSON() { response in
                    hud.mode = MBProgressHUDMode.CustomView
                    hud.customView = UIImageView(image: UIImage(named: "ic_checkmark"))
                    hud.labelText = "Success"
                    hud.hide(true, afterDelay: 1)
                    Logger.printLog(response)
            }
        }
        
        let otherAction = UIAlertAction(title: "Other", style: UIAlertActionStyle.Default) { action in
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "cancel"), style: .Cancel) {action in
        
        }
        
        alertController.addAction(offensiveAction)
        alertController.addAction(spamAction)
//        alertController.addAction(offTopicAction)
        alertController.addAction(copyrightAction)
//        alertController.addAction(wronContentAction)
        alertController.addAction(adultAction)
//        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)

        self.viewcontroller?.presentViewController(alertController, animated: true, completion: nil)
        
        self.activityDidFinish(true)
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "ic_report")
    }

}
