//
//  CommentTableViewCell.swift
//  Pixel
//
//  Created by SongFei on 15/12/13.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentView: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.avatarImageView.layer.masksToBounds = true
//        self.avatarImageView.layer.cornerRadius = (avatarImageView.frame.size.height) / 2
//        self.avatarImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindDataBy(comment: Comment) {
        avatarImageView.tag = comment.userId
        commentView.text = comment.commentBody
        usernameLabel.text = comment.fullName
        avatarImageView.sd_setImageWithURL(NSURL(string: comment.avatar)!)
    }
    
}
