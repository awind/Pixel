//
//  AboutViewController.swift
//  Pixel
//
//  Created by SongFei on 16/1/5.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    

    var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webview = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let url = NSBundle.mainBundle().URLForResource("about", withExtension:"html")
        let myRequest = NSURLRequest(URL: url!);
        webview.loadRequest(myRequest);
        self.view.addSubview(webview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
