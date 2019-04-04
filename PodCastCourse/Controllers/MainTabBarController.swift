//
//  MainTabBarController.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-15.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit


class MainTabBarContoller: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true // All NavigationControllers we create inside of this scope will have preferLageTitles set to true.
        
        
        let searchNavController = generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
        let favoritesNavController = generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        let downloadNavController = generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        
        // We add the views to the tabBar at the bottom of the view.
        viewControllers = [
        searchNavController,
        favoritesNavController,
        downloadNavController
        ]
    }
    
    
    // MARK: - Convience method
    /// Generates and returns a NavigationController with modified tabBarItem.
    /// - parameter rootviewController: The viewController used for the NavigationController
    /// - parameter title: The title for the tabBarItem
    /// - parameter image: The image for the tabBarItem
      fileprivate func generateNavigationController(with rootviewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootviewController)
        navController.navigationBar.prefersLargeTitles = true // Large titles
        rootviewController.navigationItem.title = title       // navController gets the title from the rootviewController
        navController.tabBarItem.title = title               
        navController.tabBarItem.image = image
        return navController
    }

    
    
    
    
}
