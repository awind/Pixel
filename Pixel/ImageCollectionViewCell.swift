//
//  ImageCollectionViewCell.swift
//  PX500
//
//  Created by SongFei on 15/12/3.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: self.contentView.frame)
        imageView.autoresizingMask = .FlexibleHeight
        imageView.contentMode = .ScaleAspectFit
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
