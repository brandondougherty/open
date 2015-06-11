//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "backIcon")!)
        self.addRightBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 103, height: 35))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "headerlogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}
// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net