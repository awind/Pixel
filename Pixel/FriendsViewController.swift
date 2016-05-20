//
//  FriendsViewController.swift
//  Pixel
//
//  Created by SongFei on 16/1/2.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MJRefresh

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_IDENTIFIER = "userCell"
    
    let FRIENDS = 0
    let FOLLOWERS = 1
    
    var parentNavigationController: UINavigationController?
    
    var tableView = UITableView()
    
    var userId: Int?
    var requestType: Int = 0
    var typeIdentify = "friends"
    var populatingUsers = false
    var currentPage = 1
    var totalPage = 2
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "UserSearchTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(searchUsers))
        self.tableView.mj_footer.hidden = true
        self.view.addSubview(tableView)
        self.tableView.mj_header.beginRefreshing()
    }
    
    func searchUsers() {
        if currentPage > totalPage {
            return
        }
        if populatingUsers {
            return
        }
        
        var request: Router = Router.UserFriends(self.userId!, self.currentPage)
        if self.requestType == FOLLOWERS {
            request = Router.UserFollowers(self.userId!, self.currentPage)
            typeIdentify = "followers"
        }
        
        self.populatingUsers = true
        Alamofire.request(request)
            .responseSwiftyJSON { response in
                guard let json = response.result.value else {
                    self.populatingUsers = false
                    return
                }
                self.parseJSON(json)
                self.populatingUsers = false
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
        }
    }
    
    func parseJSON(json: JSON) {
        if let currentPage = json["page"].int, totalPage = json["\(self.typeIdentify)_pages"].int {
            self.currentPage = currentPage
            self.totalPage = totalPage
        }
        for (_, subJson):(String, JSON) in json[self.typeIdentify] {
            
            if let id = subJson["id"].int, name = subJson["fullname"].string, avatar = subJson["userpic_url"].string {
                let user = User(id: id, username: name, avatar: avatar)
                self.users.append(user)
            }
        }
        self.tableView.reloadData()
        self.currentPage += 1
    }
    
    // MARK: MJRefresh
    func pullDownRefresh() {
        self.currentPage = 1
        self.totalPage = 2
        self.users.removeAll()
        self.tableView.reloadData()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height {
            self.tableView.mj_footer.beginRefreshing()
            searchUsers()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! UserSearchTableViewCell
        
        let user = self.users[indexPath.row]
        cell.username.text = user.username
        cell.avatar.sd_setImageWithURL(NSURL(string: user.avatar), placeholderImage: UIImage(named: "user_placeholder"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.users[indexPath.row]
        let userVC = UserInfoViewController()
        userVC.userId = user.id
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
