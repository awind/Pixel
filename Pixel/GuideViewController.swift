//
//  GuidanceViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/9.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import PureLayout

class GuideViewController: UIViewController {
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        
        initViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViews() {
        let imageView = UIImageView(frame: self.view.frame)
        let bgImage = UIImage(named: "bg_guide")
        imageView.image = bgImage
        self.view.addSubview(imageView)
        
        let tourButton = UIButton(frame: CGRectMake(0 , screenHeight-64, screenWidth / 2, 64))
        tourButton.setTitle("随便看看", forState: .Normal)
        tourButton.addTarget(self, action: "enter:", forControlEvents: .TouchUpInside)
        tourButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        tourButton.backgroundColor = UIColor(red: 158/255, green: 63/255, blue: 29/255, alpha: 1.0)
        self.view.addSubview(tourButton)
        let loginButton = UIButton(frame: CGRectMake(screenWidth / 2 , screenHeight-64, screenWidth / 2, 64))
        loginButton.setTitle("登录", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor(red: 66/255, green: 136/255, blue: 217/255, alpha: 1.0)
        loginButton.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loginButton)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func login(sender: UIButton) {

        let authVC = AuthViewController()
        self.presentViewController(UINavigationController(rootViewController: authVC), animated: true, completion: nil)

    }
    
    func enter(sender: UIButton) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "first")
        let mainVC = MainViewController()
        self.presentViewController(UINavigationController(rootViewController: mainVC), animated: true, completion: nil)
    }

}
