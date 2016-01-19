//
//  MainViewController.swift
//  Pixel
//
//  Created by SongFei on 15/12/10.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pixel"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_user"), style: .Plain, target: self, action: "userTapped")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "toggleSearch")
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        var controllerArray : [UIViewController] = []
        
        let popularVC = ImageCollectionViewController()
        popularVC.title = NSLocalizedString("TITLE_POPULAR", comment: "")
        popularVC.requestType = Int(0)
        popularVC.parentNavigationController = self.navigationController
        controllerArray.append(popularVC)
        
        let highRatedVC = ImageCollectionViewController()
        highRatedVC.title = NSLocalizedString("TITLE_HIGHRATED", comment: "")
        highRatedVC.requestType = Int(1)
        highRatedVC.parentNavigationController = self.navigationController
        controllerArray.append(highRatedVC)
        
        let upcomimgVC = ImageCollectionViewController()
        upcomimgVC.title = NSLocalizedString("TITLE_UPCOMING", comment: "")
        upcomimgVC.requestType = Int(2)
        upcomimgVC.parentNavigationController = self.navigationController
        controllerArray.append(upcomimgVC)
        
        let editorVC = ImageCollectionViewController()
        editorVC.title = NSLocalizedString("TITLE_EDITOR", comment: "")
        editorVC.requestType = Int(3)
        editorVC.parentNavigationController = self.navigationController
        controllerArray.append(editorVC)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 60.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.useMenuLikeSegmentedControl = true
        
        self.view.addSubview(pageMenu!.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        // check accessToken
        self.navigationController?.navigationBar.hidden = false
    }
    
    func userTapped() {
        let userVC = UserInfoViewController()
        userVC.isSelf = true
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    func toggleSearch() {
        self.navigationController?.pushViewController(MainSearchViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
