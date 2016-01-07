//
//  SearchViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/20.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController, UISearchBarDelegate, CAPSPageMenuDelegate {
    
    lazy var searchBar = UISearchBar()
    
    var photoVC = PhotoSearchViewController()
    var peopleVC = PeopleSearchViewController()

    var pageMenu: CAPSPageMenu?
    
    var keyword = ""
    var currentPageIndex = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        searchBar.frame = CGRectMake(0, 0, self.view.frame.width-20, self.view.frame.height)
        searchBar.placeholder = "搜索图片或用户"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        photoVC.title = "Photo"
        peopleVC.title = "People"
        photoVC.parentNavigationController = self.navigationController
        peopleVC.parentNavigationController = self.navigationController
        
        var controllerArray : [UIViewController] = []
        controllerArray.append(photoVC)
        controllerArray.append(peopleVC)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 60, self.view.frame.width, self.view.frame.height - 30.0), pageMenuOptions: parameters)
        pageMenu?.useMenuLikeSegmentedControl = true
        pageMenu?.delegate = self
        
        self.view.addSubview(pageMenu!.view)
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        self.currentPageIndex = index
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    // MARK: SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyword = searchText
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if self.currentPageIndex == 0 {
            self.photoVC.keyword = self.keyword
        } else {
            self.peopleVC.keyword = self.keyword
        }
        searchBar.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
