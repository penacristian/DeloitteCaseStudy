//
//  Theme.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import UIKit


class Theme {
    class func getWomensTintWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: alpha)
    }
    
    class func getMensTintWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: alpha)
    }
    
    class func getBackgroundColor() -> UIColor {
        return Theme.getBackgroundColorWithAlpha(1)
    }
    
    class func getBackgroundColorWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: alpha)
    }
    
    class func getTintColor() -> UIColor {
        return Theme.getTintColorWithAlpha(1)
    }
    
    class func getTintColorWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: alpha)
    }
    
    class func setUpViewController(viewController:UIViewController) {
        viewController.view.backgroundColor = Theme.getBackgroundColor()
    }
    
    class func customizeAppAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = Theme.getTintColor()
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = Theme.getTintColor()
    }
}