//
//  LicenseType.swift
//  Pixel
//
//  Created by SongFei on 16/1/19.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Foundation

enum LicenseType: Int {

    case Stand
    case NonCommercialAttribution
    case NonCommerciaNoDerivatives
    case NonCommercialShareAlike
    case Attribution
    case NoDerivatives
    case ShareAlike
    
    func toType() -> String {
        switch self {
        case .Stand:
            return "Standard 500px License"
        case .NonCommercialAttribution:
            return "Creative Commons License Non Commercial Attribution"
        case .NonCommerciaNoDerivatives:
            return "Creative Commons License Non Commercial No Derivatives"
        case .NonCommercialShareAlike:
            return "Creative Commons License Non Commercial Share Alike"
        case .Attribution:
            return "Creative Commons License Attribution"
        case .NoDerivatives:
            return "Creative Commons License No Derivatives"
        case .ShareAlike:
            return "Creative Commons License Share Alike"
        }
    }
    
}
