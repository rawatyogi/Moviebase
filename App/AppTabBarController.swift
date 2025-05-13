//
//  AppTabBar.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit

class AppTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor().colorWithHexString(hex: "#FFD700")
        
        UITabBar.appearance().unselectedItemTintColor = UIColor().colorWithHexString(hex: "#7A7A9A")
        UITabBar.appearance().backgroundColor = UIColor().colorWithHexString(hex: "#00002C")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.tabBar.layer.addSublayer(topBorder)
    }
}
