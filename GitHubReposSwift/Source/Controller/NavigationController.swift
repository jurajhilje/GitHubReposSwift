//
//  NavigationController.swift
//  GitHubReposSwift
//  Created by Juraj Hilje on 06/11/14.
//

import UIKit

class NavigationController: UINavigationController
{
    let k_TINT_COLOR: UIColor = UIColor(red: 133/255.0, green: 0/255.0, blue: 178/255.0, alpha: 1)
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = self.k_TINT_COLOR
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!, NSForegroundColorAttributeName: self.k_TINT_COLOR], forState: UIControlState.Normal)
        
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSForegroundColorAttributeName: self.k_TINT_COLOR]
    }
}