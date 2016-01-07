//
//  ImageInfoViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/29.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Alamofire

class ImageInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_IDENTIFIER = "infoCell"
    
    var imageId: Int?
    
    var basicInfos = [InfoCell]()
    var photoStars = [InfoCell]()
    var photoEXIFs = [InfoCell]()
    
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More"
        tableView = UITableView(frame: screenBounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerNib(UINib(nibName: "DetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        
        self.view.addSubview(tableView!)
        
        fetchImageInfo()
    }
    
    func fetchImageInfo() {
        Alamofire.request(Router.PhotoInfo(self.imageId!, ImageSize.Medium))
            .responseSwiftyJSON { response in
//                print(response)
                
                guard let json = response.result.value else {return}
                
                let photo = json["photo"]
                let createAt = photo["created_at"].string!
                let index = createAt.startIndex.advancedBy(10)
                let createDate = createAt.substringToIndex(index)
                let width = photo["width"].int!
                let height = photo["height"].int!
                
                let timeDic = InfoCell(key: "Create At", value: createDate)
                let formatDic = InfoCell(key: "Format", value: photo["image_format"].string!)
                let licenseDic = InfoCell(key: "License Type", value: "\(photo["license_type"].int!)")
                let dimension = InfoCell(key: "Dimension", value:  "\(width)x\(height)")
                self.basicInfos = [timeDic, formatDic, licenseDic, dimension]
                
                let rating = InfoCell(key: "Rating", value: "\(photo["rating"].int!)")
                let fav = InfoCell(key: "Favorites", value: "\(photo["favorites_count"].int!)")
                let votes = InfoCell(key: "Votes", value: "\(photo["votes_count"].int!)")
                let views = InfoCell(key: "Views", value: "\(photo["times_viewed"].int!)")
                let comments = InfoCell(key: "Comments", value: "\(photo["comments_count"].int!)")
                self.photoStars = [rating, fav, votes, views, comments]
                
                var cameraName = ""
                if let cameraInfo = photo["camera"].string {
                    cameraName = cameraInfo
                }
                let camera = InfoCell(key: "Camera", value: cameraName)
                var apertureInfo = ""
                if let aper = photo["aperture"].string {
                    apertureInfo = aper
                }
                let aperture = InfoCell(key: "Aperture", value: apertureInfo)
                
                var flength = ""
                if let fl = photo["focal_length"].string {
                    flength = fl
                }
                let focalLength = InfoCell(key: "Focal Length", value: flength)
                
                var isoInfo = ""
                if let ii = photo["iso"].string {
                    isoInfo = ii
                }
                let iso = InfoCell(key: "ISO", value: isoInfo)
                
                var shutterInfo = ""
                if let ss = photo["shutter_speed"].string {
                    shutterInfo = ss
                }
                let shutterSpeed = InfoCell(key: "Shutter Speed", value: shutterInfo)
                
                var takenDate = ""
                if let ti = photo["taken_at"].string {
                    takenDate = ti.substringToIndex(index)
                }
                let taken = InfoCell(key: "Taken", value: takenDate)
                self.photoEXIFs = [camera, aperture, focalLength, iso, shutterSpeed, taken]
                
                self.tableView?.reloadData()
                
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = self.basicInfos.count
        case 1:
            count = self.photoStars.count
        case 2:
            count = self.photoEXIFs.count
        default:
            break
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! DetailInfoTableViewCell
        if indexPath.section == 0 {
            cell.title.text = self.basicInfos[indexPath.row].key
            cell.detail.text = self.basicInfos[indexPath.row].value
        } else if indexPath.section == 1 {
            cell.title.text = self.photoStars[indexPath.row].key
            cell.detail.text = self.photoStars[indexPath.row].value
        } else if indexPath.section == 2 {
            cell.title.text = self.photoEXIFs[indexPath.row].key
            cell.detail.text = self.photoEXIFs[indexPath.row].value
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "Basic Info"
        switch section {
        case 1:
            title = "Photo Stars"
        case 2:
            title = "Photo EXIF"
        case 3:
            title = "Photo Tags"
        default:
            break
        }
        return title
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
