//
//  DetailImageViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/15.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD

class DetailImageViewController: UIViewController {
    let CELL_TITLE_HEADER = "titleHeader"
    let CELL_COMMENT_HEADER = "commentHeader"
    let IMAGE_INFO_CELL = "imageInfoCell"
    let CELL_IDENTIFIER = "CommentCell"
    
    var imageView: UIImageView?
    var tableView: UITableView?
    
    var photoInfo: PhotoInfo!
    var user: User!
    
    var totalCommentItems = 0
    var currentPage = 1
    var totalPages = 2
    var fetchComment = false
    
    var comments = [Comment]()
    var imageHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photo Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_share"), style: .Plain, target: self, action: "shareTapped")
        initViews()
        requestComments()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func initViews() {
        // image view & MBProgressHUD
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: self.imageHeight))
        self.imageView?.contentMode = .ScaleAspectFit

        // table view
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .None
        self.tableView?.estimatedRowHeight = 72
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.tableHeaderView = imageView
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.tableView?.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView?.registerNib(UINib(nibName: "TitleHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_TITLE_HEADER)
        self.tableView?.registerNib(UINib(nibName: "CommentHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_COMMENT_HEADER)
        self.tableView?.registerNib(UINib(nibName: "ImageInfoTableViewCell", bundle: nil), forCellReuseIdentifier: IMAGE_INFO_CELL)
        
        self.view.addSubview(self.tableView!)
        

        // display image
        self.imageView?.sd_setImageWithURL(NSURL(string: self.photoInfo.smallPicUrl!))
        let sdWebImageManager = SDWebImageManager.sharedManager()
        sdWebImageManager.downloadImageWithURL(NSURL(string: self.photoInfo.rawPicUrl!),
            options: .LowPriority,
            progress: { (receiveSize, expectSize) in
                dispatch_async(dispatch_get_main_queue(), {
                    //TODO: image load progress
                })
            },
            completed: {[weak self] (image, error, cached, finished, url) in
                if let wSelf = self {
                    dispatch_async(dispatch_get_main_queue(), {
                        wSelf.imageView!.image = image
                        //TODO: image load finish
                    })
                }
            })
        

        
    }
    
    func requestComments() {
        if self.currentPage >= self.totalPages {
            return
        }
        
        if self.fetchComment {
            return
        }
        
        fetchComment = true
        Alamofire.request(Router.Comments(self.photoInfo.id, self.currentPage))
            .responseSwiftyJSON { response in
                
                guard let json = response.result.value else {
                    self.fetchComment = false
                    return
                }
                self.parseCommentJson(json)
                self.fetchComment = false
        }
    }
    
    func parseCommentJson(json: JSON) {
        dispatch_async(dispatch_get_main_queue(), {
            if let currentPage = json["current_page"].int, totalPages = json["total_pages"].int {
                self.currentPage = currentPage
                self.totalPages = totalPages
            }
            
            for (_, subJson): (String, JSON) in json["comments"] {
                if let fullname = subJson["user"]["fullname"].string, body = subJson["body"].string,
                    avatar = subJson["user"]["userpic_url"].string, userId =  subJson["user"]["id"].int {
                        let comment = Comment(fullName: fullname, avatar: avatar, commentBody: body, userId: userId)
                        self.comments.append(comment)
                }
            }
            self.tableView?.reloadData()
            self.currentPage += 1
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height {
            requestComments()
        }
    }
    
    
    // MARK: View Tapped
    
    func votePhoto(sender: UIButton) {
        if !Account.checkIsLogin() {

            let alert = UIAlertController(title: nil, message: NSLocalizedString("LOGIN_MESSAGE", comment: "loginMessage"), preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertConfirm = UIAlertAction(title: NSLocalizedString("CONFIRM", comment: "confirm"), style: UIAlertActionStyle.Default) { alertConfirm in
                self.presentViewController(UINavigationController(rootViewController: AuthViewController()), animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "confirm"), style: UIAlertActionStyle.Cancel) { (cancle) -> Void in
                
            }
            
            alert.addAction(alertConfirm)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // 1 -> like,  0 -> dislike
        Alamofire.request(Router.VotePhoto(self.photoInfo.id, 1))
            .responseSwiftyJSON { response in
//                print("vote photo \(response)")

                sender.setImage(UIImage(named: "ic_like_highlight"), forState: .Normal)
                
                self.photoInfo.liked = true
        }
    }
    
    func shareTapped() {
        let urlToShare = self.photoInfo.rawPicUrl!
        let array = ["\(urlToShare)"]
        let reportActivity = ReportPhotoActivity()
        reportActivity.photoId = self.photoInfo.id
        reportActivity.viewcontroller = self
        reportActivity.view = self.view
        let applicationActivities = [reportActivity]
        let activityVC = UIActivityViewController(activityItems: array, applicationActivities: applicationActivities)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func commentTapped() {
        if !Account.checkIsLogin() {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("LOGIN_MESSAGE", comment: "loginMessage"), preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertConfirm = UIAlertAction(title: NSLocalizedString("CONFIRM", comment: "confirm"), style: UIAlertActionStyle.Default) { alertConfirm in
                self.presentViewController(UINavigationController(rootViewController: AuthViewController()), animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "cancel"), style: UIAlertActionStyle.Cancel) { (cancle) -> Void in
                
            }
            
            alert.addAction(alertConfirm)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)

            return
        }
        
        let alert = UIAlertController(title: nil, message: NSLocalizedString("COMMENT_PHOTO", comment: "commentPhoto"), preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = NSLocalizedString("COMMENT_TEXT_FIELD_HINT", comment: "commentHint")
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("COMMENT", comment: "comment"), style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if let commentBody = textField.text {
                Alamofire.request(Router.CommentPhoto(self.user.id, commentBody))
                    .responseSwiftyJSON { response in
                        
                }
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "cancel"), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func moreTapped() {
        let imageInfoVC = ImageInfoViewController()
        imageInfoVC.imageId = self.photoInfo.id
        self.navigationController?.pushViewController(imageInfoVC, animated: true)
    }
    
    func userAvatarTapped(sender: UITapGestureRecognizer) {
        let userId = sender.view?.tag
        let userInfoVC = UserInfoViewController()
        userInfoVC.userId = userId
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
}


extension DetailImageViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var identifier = IMAGE_INFO_CELL
        if indexPath.section == 1 {
            identifier = CELL_IDENTIFIER
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        if let infoCell = cell as? ImageInfoTableViewCell {
            infoCell.selectionStyle = .None
            infoCell.bindDataBy(self.photoInfo)
            
            infoCell.likeBtn.addTarget(self, action: "votePhoto:", forControlEvents: .TouchUpInside)
            infoCell.share.addTarget(self, action: "commentTapped", forControlEvents: .TouchUpInside)
            infoCell.more.addTarget(self, action: "moreTapped", forControlEvents: .TouchUpInside)
            
            infoCell.userAvatar.tag = self.user.id
            let userSingleTap = UITapGestureRecognizer(target: self, action: "userAvatarTapped:")
            userSingleTap.numberOfTapsRequired = 1
            infoCell.userAvatar.addGestureRecognizer(userSingleTap)
        }
        
        if let commentCell = cell as? CommentTableViewCell {
            if indexPath.row % 2 == 0 {
                commentCell.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
            }
            let comment = self.comments[self.comments.startIndex.advancedBy(indexPath.row)]
            commentCell.bindDataBy(comment)
            
            let userSingleTap = UITapGestureRecognizer(target: self, action: "userAvatarTapped:")
            userSingleTap.numberOfTapsRequired = 1
            commentCell.avatarImageView.addGestureRecognizer(userSingleTap)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var identifier = CELL_COMMENT_HEADER
        if section == 0 {
            identifier = CELL_TITLE_HEADER
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)! as UITableViewCell
        
        if let titleHeader = cell as? TitleHeaderTableViewCell {
            titleHeader.titleView.text = self.photoInfo.name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(48)
        }
        return CGFloat(36)
    }
    
    
    
}
