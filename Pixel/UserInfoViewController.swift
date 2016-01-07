//
//  UserInfoViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/14.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire


class UserInfoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    
    var isSelf = false
    var rightButton: UIBarButtonItem?
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User"
        if isSelf {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .Plain, target: self, action: "settings")
        } else {
            rightButton = UIBarButtonItem(title: "Follow", style: UIBarButtonItemStyle.Plain, target: self, action: "updateFollowStatus")
            self.navigationItem.rightBarButtonItem = rightButton
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = (avatarImageView.frame.size.height) / 2
        avatarImageView.clipsToBounds = true

        scrollView.delegate = self
        
        if Account.checkIsLogin() && isSelf{
            requestSelfInfo()
        } else if self.userId != nil {
            requestUserInfo()
        } else {
            // not login, add avatar
            avatarImageView.image = UIImage(named: "user_placeholder")
            let userSingleTap = UITapGestureRecognizer(target: self, action: "userAvatarTapped")
            userSingleTap.numberOfTapsRequired = 1
            avatarImageView.addGestureRecognizer(userSingleTap)
            usernameLabel.text = "点击头像登录"
        }
    }
    
    func requestSelfInfo() {
        
        Alamofire.request(Router.Users())
            .responseSwiftyJSON { response in
                
                if let json = response.result.value {
                    if let username = json["user"]["username"].string, avatar = json["user"]["userpic_https_url"].string,id = json["user"]["id"].int, photosCount = json["user"]["photos_count"].int, friendsCount = json["user"]["friends_count"].int, followersCount = json["user"]["followers_count"].int {
                        self.userId = id
                        let user = User(id: id, username: username, avatar: avatar)
                        user.email = json["user"]["email"].string
                        var city = ""
                        var country = ""
                        if let cityString = json["user"]["city"].string {
                            city = cityString
                        }
                        if let countryString = json["user"]["country"].string {
                            country = countryString
                        }
                        user.location = "\(city) \(country)"
                        user.domain = json["user"]["domain"].string
                        user.coverURL = json["user"]["cover_url"].string
                        user.followersCount = followersCount
                        user.friendsCount = friendsCount
                        user.photosCount = photosCount
                        self.updateUserInfo(user)
                    }
                }
        }
    }
    
    func requestUserInfo() {
        Alamofire.request(Router.UsersShow(self.userId!))
            .responseSwiftyJSON { response in
                if let json = response.result.value {
                    if let username = json["user"]["username"].string, avatar = json["user"]["userpic_https_url"].string, id = json["user"]["id"].int, photosCount = json["user"]["photos_count"].int, friendsCount = json["user"]["friends_count"].int, followersCount = json["user"]["followers_count"].int {
                        self.userId = id
                        let user = User(id: id, username: username, avatar: avatar)
                        user.email = json["user"]["email"].string
                        var city = ""
                        var country = ""
                        if let cityString = json["user"]["city"].string {
                            city = cityString
                        }
                        if let countryString = json["user"]["country"].string {
                            country = countryString
                        }
                        user.location = "\(city) \(country)"
                        user.domain = json["user"]["domain"].string
                        user.coverURL = json["user"]["cover_url"].string
                        user.followersCount = followersCount
                        user.friendsCount = friendsCount
                        user.photosCount = photosCount
                        if !self.isSelf && Account.checkIsLogin() {
                            user.following = json["user"]["following"].bool!
                        }
                        self.updateUserInfo(user)
                    }
                }

        }

    }
    
    func updateUserInfo(user: User) {
        if let coverUrl = user.coverURL {
            self.coverImageView.sd_setImageWithURL(NSURL(string: coverUrl), placeholderImage: UIImage(named: "ic_user_header"))
        }
        self.avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar), placeholderImage: UIImage(named: "user_placeholder"))
        self.usernameLabel.text = user.username
        self.numberOfFollowersLabel.text = "\(user.followersCount!)"
        self.numberOfPhotosLabel.text = "\(user.photosCount!)"
        self.numberOfFriendsLabel.text = "\(user.friendsCount!)"
        if let email = user.email {
            self.birthdayLabel.text = email
        }
        if let location = user.location {
            self.locationLabel.text = location
        }
        if let domain = user.domain {
            self.domainLabel.text = domain
        }
        
        if !isSelf {
            if user.following {
                self.rightButton?.title = "Following"
            } else {
                self.rightButton?.title = "Follow"
            }
        }
        
    }
    
    func updateFollowStatus() {
        if !Account.checkIsLogin() {
            let alert = UIAlertController(title: nil, message: "未登录无法赞这张照片，现在去登录吗？", preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { alertConfirm in
                self.presentViewController(UINavigationController(rootViewController: AuthViewController()), animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (cancle) -> Void in
                
            }
            
            alert.addAction(alertConfirm)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)

            return
        }
        
        if self.rightButton?.title == "Follow" {
            Alamofire.request(Router.FollowUser(self.userId!))
                .responseSwiftyJSON { response in
                    self.rightButton?.title = "Following"
                    
            }
        } else {
            Alamofire.request(Router.UnFollowUser(self.userId!))
                .responseSwiftyJSON { response in
                    self.rightButton?.title = "Follow"
            }
        }
    }
    
    // MARK: UIBarButtonItem
    
    func settings() {
        let settingsVC = UINavigationController(rootViewController: SettingViewController())
        self.presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    
    @IBAction func photoButtonTapped(sender: UIButton) {
        if let id = self.userId {
            let galleryVC = ImageCollectionViewController()
            galleryVC.requestType = 4
            galleryVC.userId = id
            galleryVC.title = "Photos"
            galleryVC.parentNavigationController = self.navigationController
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
    }
    
    
    @IBAction func friendButtonTapped(sender: UIButton) {
        if let id = self.userId {
            let friendVC = FriendsViewController()
            friendVC.userId = id
            self.navigationController?.pushViewController(friendVC, animated: true)
        }
    }
    
    
    @IBAction func followerButtonTapped(sender: UIButton) {
        if let id = self.userId {
            let friendVC = FriendsViewController()
            friendVC.userId = id
            friendVC.requestType = 1
            self.navigationController?.pushViewController(friendVC, animated: true)
        }
        
    }
    
    func userAvatarTapped() {
        let signInVC = AuthViewController()
        self.presentViewController(UINavigationController(rootViewController: signInVC), animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
