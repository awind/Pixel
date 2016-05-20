//
//  PeopleSearchViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/27.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MJRefresh

class PeopleSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_IDENTIFIER = "userCell"
    
    var parentNavigationController: UINavigationController?
    var keyword: String = "" {
        
        didSet{
            currentPage = 1
            totalPage = 2
            populatingUsers = false
            users.removeAll()
            self.tableView.reloadData()
            self.tableView.mj_header.hidden = false
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    var lastContentOffsetY: CGFloat = CGFloat(0)
    
    var tableView = UITableView(frame: screenBounds)
    
    var populatingUsers = false
    var currentPage = 1
    var totalPage = 2
    var users = [User]()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "UserSearchTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(searchUsers))
        
        self.view.addSubview(tableView)
    }
    
    func searchUsers() {
        if currentPage > totalPage {
            return
        }
        if populatingUsers {
            return
        }
        
        if self.keyword.isEmpty {
            return
        }
        
        self.populatingUsers = true
        Alamofire.request(Router.SearchUsers(self.keyword, self.currentPage))
            .responseSwiftyJSON { response in
//                print("\(response)")
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
        if let currentPage = json["current_page"].int, totalPage = json["total_pages"].int {
            self.currentPage = currentPage
            self.totalPage = totalPage
        }
        for (_, subJson):(String, JSON) in json["users"] {
            
            if let id = subJson["id"].int, name = subJson["fullname"].string, avatar = subJson["userpic_url"].string {
                let user = User(id: id, username: name, avatar: avatar)
                self.users.append(user)
            }
        }
        self.tableView.reloadData()
        self.currentPage++
    }
    
    // MARK: MJRefresh
    func pullDownRefresh() {
        self.currentPage = 1
        self.totalPage = 2
        self.users.removeAll()
        self.tableView.reloadData()
        searchUsers()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height {
            self.tableView.mj_footer.beginRefreshing()
            if self.currentPage >= self.totalPage {
                return
            }
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
        self.parentNavigationController?.pushViewController(userVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
