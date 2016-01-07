//
//  Account.swift
//  Pixel
//
//  Created by SongFei on 16/1/4.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Foundation

class Account {

    static func checkIsLogin() -> Bool {
        let oauthToken = getOauthToken()
        if oauthToken.isEmpty {
            return false
        }
        return true
    }
    
    static func getOauthToken() -> String {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var oauthToken: String = ""
        if let accessToken = userDefaults.valueForKey("accessToken") {
            oauthToken = accessToken as! String
//            print("oauthToken: \(oauthToken)")
        }
        return oauthToken
    }
}
