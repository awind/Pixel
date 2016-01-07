//
//  ImageDetailTableViewCell.swift
//  Pixel
//
//  Created by SongFei on 15/12/15.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import MBProgressHUD


class ImageDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var LikesLabel: UILabel!
    var progressHUD: MBProgressHUD?
    var bgView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        progressHUD = MBProgressHUD(frame: self.contentView.frame)
        progressHUD?.mode = .Determinate
        self.contentView.addSubview(progressHUD!)
        progressHUD?.show(true)
        
        bgView = UIView(frame: self.photoImage.frame)
        //bgView?.backgroundColor = UIColor(red: 24.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 0.7)
        self.contentView.addSubview(bgView!)
    }
    
    func updateProgress(progress: Float) {
        progressHUD?.progress = progress
    }
    
    func dismissProgressHUD() {
        progressHUD?.hide(true)
        bgView?.hidden = true
    }
    
    
}
