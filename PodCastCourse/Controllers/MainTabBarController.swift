//
//  MainTabBarController.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-15.
//  Copyright © 2019 Armend. All rights reserved.
//

// ---- FIRST SEARCH VIEW ----

import UIKit


class MainTabBarContoller: UITabBarController {
    
    let playerDetailsView = PlayerDetailsView.initFromNib()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        tabBar.tintColor = .purple
        
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        UINavigationBar.appearance().prefersLargeTitles = true // All NavigationControllers we create inside of this scope will have preferLageTitles set to true since we used the static method.
        
        
        // Creating barItems with a navController.
        let searchNavController = generateNavigationController(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
        let favoritesNavController = generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        let downloadNavController = generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        
        // We add the views to the tabBar at the bottom of the view.
        viewControllers = [
        searchNavController,
        favoritesNavController,
        downloadNavController
        ]
        
        setupPlayerDetailsView()

    }
    
    // MARK: - Animate Methods
    @objc func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        })
    }
    
    func maximizePlayerDetails(with episode: Episode?) {
        if episode != nil {
        playerDetailsView.episode = episode
        }
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
//            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
            
        })
    }
    
    // MARK: - Convience method
    /// Generates and returns a NavigationController with a title and image for the tab bar item.
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
    
    /// Setups a PlayerDetailsView view with autolayout.
    fileprivate func setupPlayerDetailsView() {
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        // auto layout
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        NSLayoutConstraint.activate([
            maximizedTopAnchorConstraint,
            playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        
    }
    
}
