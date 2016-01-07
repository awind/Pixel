//
//  ImageDetailViewController.swift
//  PX500
//
//  Created by SongFei on 15/12/3.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire

class ImageDetailViewController: ParallaxTableViewController {
    
    let CELL_IDENTIFIER = "CommentCell"

    var imageName: String!
    var imageId: Int!
    
    var totalCommentItems = 0
    var currentPage = 1
    var maxPage = 2
    var fetchComment = false
    
    var comments = Set<Comment>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRectMake(0, 0, 300, 40))
        label.text = imageName
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Noteworthy-Light", size: 24)
        label.textAlignment = .Center
        
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.translucent = false


        initViews()
        requestImageInfo()
        requestComments()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "imageDetail")
    }
    
    func initViews() {
        tableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    func requestImageInfo() {
        Alamofire.request(Router.PhotoInfo(imageId, .XLarge))
            .responseJSON() {
                response in
                guard let jsons = response.result.value as? NSDictionary else {return}
                self.parseImageDetailJson(jsons)
        }
        
    }
    
    func requestComments() {
        if self.currentPage > self.maxPage {
            return
        }
        
        if self.fetchComment {
            return
        }
        
        fetchComment = true
        
        print("current page: \(self.currentPage)")
        Alamofire.request(Router.Comments(imageId, self.currentPage))
            .responseJSON {
                response in
                
                if let jsons = response.result.value as? NSDictionary {
                    self.parseCommentJson(jsons)
                }
        }

    }
    
    func parseImageDetailJson(jsons: NSDictionary) {
        guard let photoJsons = jsons.valueForKey("photo") as? NSDictionary else {return}
        let url = photoJsons.valueForKey("image_url") as! String
        let height = photoJsons.valueForKey("height") as! Int
        let width = photoJsons.valueForKey("width") as! Int
        
        self.imageHeight = (CGFloat(height) * self.view.frame.size.width) / CGFloat(width)
        self.tableView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
        
        print("imageHeight \(self.imageHeight)")
        
        self.imageView.setImageWithURL(NSURL(string: url)!, usingActivityIndicatorStyle: .WhiteLarge)
    }
    
    func parseCommentJson(jsons: NSDictionary) {
        self.maxPage = jsons["total_pages"]!.integerValue
        self.totalCommentItems = jsons["total_items"]!.integerValue
        self.fetchComment = false
        self.currentPage++
        print("maxpage: \(self.maxPage)")
        if let jsonArray = jsons["comments"] as? NSArray {
            for i in 0 ..< jsonArray.count {
                if let item = jsonArray[i] as? NSDictionary {
                    let fullname = item["user"]!["fullname"] as! String
                    let avatar = item["user"]!["userpic_url"] as! String
                    let body = item["body"] as! String
                    let comment = Comment(fullName: fullname, avatar: avatar, commentBody: body)
                    self.comments.insert(comment)
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func imageDetail() {
        
    }
    
    func buildTableHeaderView() -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = "Comments(" + "\(self.totalCommentItems)" + ")"
        view.addSubview(label)
        label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 1, left: 12, bottom: 1, right: 0))
        return view
    }

    // MARK: UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! CommentTableViewCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        }
        
        let comment = self.comments[self.comments.startIndex.advancedBy(indexPath.row)]
        cell.commentLabel.text = comment.commentBody
        cell.usernameLabel.text = comment.fullName
        cell.avatarImageView.sd_setImageWithURL(NSURL(string: comment.avatar)!)
        
        return cell
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollOffset = tableView.contentOffset.y + imageHeight
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            requestComments()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
