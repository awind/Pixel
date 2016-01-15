//
//  Logger.swift
//  Pixel
//
//  Created by SongFei on 16/1/11.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Foundation

class Logger {
    
    
    class func printLog<T>(message: T,
        file: String = __FILE__,
        method: String = __FUNCTION__,
        line: Int = __LINE__) {
            if DEBUG_BUILD {
                print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
            }
    }
}
