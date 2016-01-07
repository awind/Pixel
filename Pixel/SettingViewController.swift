//
//  SettingViewController.swift
//  Pixel
//
//  Created by Fei on 15/12/30.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Armchair
import MessageUI
import MBProgressHUD

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var cacheSize: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    var size = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        cacheFolderSize()
        cacheSize.text = "\(size/(1024*1024))MB"
        
        if !Account.checkIsLogin() {
            logoutButton.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func about(sender: AnyObject) {
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    
    @IBAction func clear(sender: UIButton) {
        let message = "\(self.size/(1024*1024))MB缓存"
        let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle: UIAlertControllerStyle.Alert)

        let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { alertConfirm in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .Determinate
            hud.labelText = "Loading";
            dispatch_async(dispatch_get_main_queue(), {
                self.clearCacheFolder()
                hud.hide(true)
                self.cacheSize.text = "0MB"
                self.size = 0
            })
        
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (cancle) -> Void in
            
        }
        
        alert.addAction(alertConfirm)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func review(sender: AnyObject) {
        Armchair.rateApp()
    }

    @IBAction func logout(sender: AnyObject) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("accessToken")
        self.presentViewController(GuideViewController(), animated: true, completion: nil)
    }
    

    @IBAction func feedback(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    
    func done() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["philsongfei@gmail.com"])
        mailComposerVC.setSubject("Feedback for Pixel")
        mailComposerVC.setMessageBody("Some Advice for Pixel", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertVC = UIAlertController(title: "无法发送邮件", message: "您的设备无法发送邮件，请检查您的邮件配置。", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertVC.addAction(confirmAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func cacheFolderSize() {
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
//        print(cachePath)
        let files = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
        
        for p in files!{
            let path = cachePath!.stringByAppendingFormat("/\(p)")
            let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
            for (abc,bcd) in floder {
                if abc == NSFileSize {
                    size += bcd.integerValue
                }
            }
        }
    }
    
    func clearCacheFolder() {
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
//        print(cachePath)
        let files = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
        
        for p in files!{
            let path = cachePath!.stringByAppendingFormat("/\(p)")

            if(NSFileManager.defaultManager().fileExistsAtPath(path)){
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                } catch {
                    print("Error !!!!!")
                }
            }
        }
    }
}