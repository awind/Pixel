//
//  PhotoInfo.swift
//  PX500
//
//  Created by SongFei on 15/12/3.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class PhotoInfo: NSObject {
    let id: Int
    let name: String
    let width: CGFloat
    let height: CGFloat
    
    var smallPicUrl: String?
    var rawPicUrl: String?
    var user: User?
    
    var likesCount: Int?
    var viewsCount: Int?
    var commentsCount: Int?
    
    var highest: Float?
    var pulse: Float?
    var views: Int?
    var camera: String?
    var desc: String?
    var liked = false
    
    init(id: Int, name: String, width: CGFloat, height: CGFloat) {
        self.id = id
        self.name = name
        self.width = width
        self.height = height
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return (object as! PhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as PhotoInfo).id
    }
    
}
