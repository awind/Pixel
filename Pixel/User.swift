//
//  User.swift
//  Pixel
//
//  Created by SongFei on 15/12/9.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: Int
    var username: String
    var avatar: String
    var email: String?
    var coverURL: String?
    var photosCount: Int?
    var friendsCount: Int?
    var followersCount: Int?
    var birthday: String?
    var location: String?
    var domain: String?
    var following = false
    
    init(id: Int, username: String, avatar: String) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
