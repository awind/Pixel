//
//  DetailInfoTableViewCell.swift
//  Pixel
//
//  Created by SongFei on 15/12/29.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
