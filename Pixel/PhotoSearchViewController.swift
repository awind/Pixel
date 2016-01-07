//
//  PhotoSearchViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/27.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import Alamofire
import UIKit
import SDWebImage
import MJRefresh

class PhotoSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CHTCollectionViewDelegateWaterfallLayout {

    let ImageCellIdentifier = "ImageCell"
    
    var parentNavigationController: UINavigationController?
    var keyword: String = "" {
        
        didSet{
            self.photos.removeAll()
            self.collectionView.reloadData()
            currentPage = 1
            totalPage = 2
            populatingPhotos = false
            self.collectionView.mj_header.hidden = false
            self.collectionView.mj_header.beginRefreshing()
            searchPhotos()
        }
    }
    
    var collectionView: UICollectionView!
    var photos = [PhotoInfo]()
    
    var populatingPhotos = false
    var currentPage = 1
    var totalPage = 2
    
    var lastContentOffsetY: CGFloat = CGFloat(0)
    var itemWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        searchPhotos()
    }
    
    func initViews() {
        self.itemWidth = (screenWidth / 2) - 2
        
        // UICollectionView FlowLayout
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumColumnSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        // UICollectionView init
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(ImageCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ImageCellIdentifier)
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullDownRefresh")
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "searchPhotos")
        self.collectionView.mj_header.hidden = true
        
        self.view.addSubview(collectionView)
    }
    
    func searchPhotos() {
        if currentPage >= totalPage {
            return
        }
        
        if self.keyword.isEmpty {
            return
        }
        
        let request: Router = Router.SearchPhotos(self.keyword, self.currentPage)
        
        if populatingPhotos {
            return
        }
        
        populatingPhotos = true
        Alamofire.request(request)
            .responseSwiftyJSON { response in
                guard let json = response.result.value else {
                    self.populatingPhotos = false
                    return
                }
                self.parseJSON(json)
                self.populatingPhotos = false
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.endRefreshing()
                
        }
    }
    
    func parseJSON(json: JSON) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
            if let currentPage = json["current_page"].int, totalPage = json["total_pages"].int {
                self.currentPage = currentPage
                self.totalPage = totalPage
            }
            let lastItem = self.photos.count
            for (_, subJson):(String, JSON) in json["photos"] {
                
                if let id = subJson["id"].int, name = subJson["name"].string, width = subJson["width"].int, height = subJson["height"].int, desc = subJson["description"].string {
                    let photoInfo = PhotoInfo(id: id, name: name, width: CGFloat(width), height: CGFloat(height))
                    let likesCount = subJson["favorites_count"].int!
                    let commentsCount = subJson["comments_count"].int!
                    let voteCount = subJson["votes_count"].int!
                    if let liked = subJson["liked"].bool {
                        photoInfo.liked = liked
                    }
                    photoInfo.likesCount = likesCount
                    photoInfo.commentsCount = commentsCount
                    photoInfo.viewsCount = voteCount
                    photoInfo.desc = desc
                    // parse image url
                    for (_, imageUrlJson):(String, JSON) in subJson["images"] {
                        if imageUrlJson["size"].int == 6 {
                            photoInfo.rawPicUrl = imageUrlJson["https_url"].string
                        } else if imageUrlJson["size"].int == 20 {
                            photoInfo.smallPicUrl = imageUrlJson["https_url"].string
                        }
                    }
                    // parse user info
                    if let id = subJson["user"]["id"].int, username = subJson["user"]["username"].string, avatarUrl = subJson["user"]["userpic_https_url"].string {
                        let user = User(id: id, username: username, avatar: avatarUrl)
                        photoInfo.user = user
                    }
                    self.photos.append(photoInfo)
                }
            }
            
            let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }
            
            self.currentPage += 1
        }
    }
    
    func pullDownRefresh() {
        self.collectionView.mj_header.beginRefreshing()
        self.currentPage = 1
        self.totalPage = 2
        self.photos.removeAll()
        self.collectionView.reloadData()
        searchPhotos()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height {
            self.collectionView.mj_footer.beginRefreshing()
            if self.currentPage >= self.totalPage {
                return
            }
            searchPhotos()
        }
    }
    
    
    // MARK: UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView.mj_footer.hidden = self.photos.count == 0
        return self.photos.count
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailImageViewController()
        let photoInfo = self.photos[indexPath.item]
        detailVC.photoInfo = photoInfo
        detailVC.imageHeight = (photoInfo.height * screenWidth) / photoInfo.width
        detailVC.user = photoInfo.user
        detailVC.hidesBottomBarWhenPushed = true
        parentNavigationController!.pushViewController(detailVC, animated: true)
        self.parentViewController?.navigationController?.navigationBar.hidden = true
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCellIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        let imageUrl = self.photos[indexPath.item].smallPicUrl!
        cell.imageView.setImageWithURL(NSURL(string: imageUrl), usingActivityIndicatorStyle: .Gray)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let photo = self.photos[indexPath.item]
        let itemHeight = (photo.height * self.itemWidth) / photo.width
        return CGSize(width: self.itemWidth, height: itemHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
