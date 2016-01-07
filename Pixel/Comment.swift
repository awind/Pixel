//
//  Comment.swift
//  Pixel
//
//  Created by SongFei on 15/12/4.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class Comment: NSObject {
    let fullName: String
    let avatar: String
    let commentBody: String
    let userId: Int
   
    init(fullName: String, avatar: String, commentBody: String, userId: Int) {
        self.fullName = fullName
        self.avatar = avatar
        self.commentBody = commentBody
        self.userId = userId
    }
    
}
