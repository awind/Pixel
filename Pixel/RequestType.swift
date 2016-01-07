//
//  RequestType.swift
//  Pixel
//
//  Created by SongFei on 16/1/2.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Foundation

public enum RequestType {
    case POPULAR
    case HIGHRATED
    case UPCOMING
    case EDITOR
    case SEARCH
    case USER(Int)
}
