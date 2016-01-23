//
//  AuthViewController.swift
//  SwifterDemoiOS
//
//  Copyright (c) 2014 Matt Donnelly.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import MBProgressHUD


class AuthViewController: UIViewController, UIWebViewDelegate {
    
    let CONSUMER_KEY = "7AqOElDfu35aVav8bgztEdMWLVojPEFZoAp66JJw"
    let CONSUMER_SECRET = "aoDBftdIjLU5V8mMX2TBXOyjjCv9wejjEAkOzsOk"
    let oauthCallback = "https://www.apple.com"
    
    var webView: UIWebView!
    var client: PixelOAuthClient!
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "500px Authorize"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        webView.delegate = self
        self.view.addSubview(webView)
        
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = NSLocalizedString("LOADING", comment: "loading")
        self.view.addSubview(hud)
        
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies!  as [NSHTTPCookie]
        {
            storage.deleteCookie(cookie)
        }
        NSUserDefaults.standardUserDefaults()
        
        client = PixelOAuthClient(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
    
        client.postOAuthRequestTokenWithCallbackURL(NSURL(string: oauthCallback)!, success: {
            accessToken  in
            
            let authorizeURL = "https://api.500px.com/v1/oauth/authorize?oauth_token=\(self.client.oauthToken.key)&oauth_callback=\(self.oauthCallback)"
            let url = NSURL(string: authorizeURL)!
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
            
            }, failure: nil)
    }
    
    
    // MARK: UIWebView
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        let url = request.URL!
        let callbackurl = "https://www.apple.com/?"
        if url.URLString.hasPrefix("\(callbackurl)") {
            let parameters = url.query!.paramtersFromQueryString()
            client.oauthToken.verifier = parameters["oauth_verifier"]
            
            self.client.postOAuthAccessTokenWithRequestToken(NSURL(string: self.oauthCallback)!, success: { accessToken in
                
                if let _ = accessToken?.key {

                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setValue(accessToken?.key, forKey: "accessToken")
                    userDefault.setBool(true, forKey: "first")
                    
                    self.presentViewController(UINavigationController(rootViewController: MainViewController()), animated: true, completion: nil)
                    
                }
                
                }, failure: { error in

            })

        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hud.hidden = true
    }
    
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}