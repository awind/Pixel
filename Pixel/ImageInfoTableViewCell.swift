//
//  ImageInfoTableViewCell.swift
//  Pixel
//
//  Created by SongFei on 15/12/28.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class ImageInfoTableViewCell: UITableViewCell {
    

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = (userAvatar.frame.height) / 2
        userAvatar.clipsToBounds = true
        userAvatar.contentMode = .ScaleAspectFit

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindDataBy(photoInfo: PhotoInfo) {
        let attrStr = try! NSAttributedString(
            data: "<html><body>\(photoInfo.desc!)</body></html>".dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        descript.attributedText = attrStr
        username.text = photoInfo.user?.username
        userAvatar.sd_setImageWithURL(NSURL(string: (photoInfo.user?.avatar)!)!, placeholderImage: UIImage(named: "user_placeholder"))
        likeLabel.text = "\(photoInfo.likesCount!) Likes"
        views.text = "\(photoInfo.viewsCount!) Views"
        if photoInfo.liked {
            likeBtn.setImage(UIImage(named: "ic_like_highlight"), forState: .Normal)
        }

    }
    
}
