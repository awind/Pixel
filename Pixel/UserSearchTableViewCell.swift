//
//  UserSearchTableViewCell.swift
//  Pixel
//
//  Created by SongFei on 15/12/28.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = CGFloat(42) / 2
        avatar.clipsToBounds = true
        avatar.contentMode = .ScaleAspectFit
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.avatar.frame = CGRect(x: 16, y: 11, width: 42, height: 42)
    }
    
}
