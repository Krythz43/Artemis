//
//  AppNavigationViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 03/02/23.
//

import UIKit

class AppNavigationViewController: UINavigationController {
    
    private var appNavigationTabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(appNavigationTabBar)
        appNavigationTabBar = createTabBar()
        view.addSubview(appNavigationTabBar.view)
        appNavigationTabBar.didMove(toParent: self)
    }
    
    func createSearchNavController () -> UINavigationController {
        let searchVC = SeachVCViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "homekit"), tag: 1)
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavNavController () -> UINavigationController {
        let searchVC = SourcesList()
        searchVC.title = "Sources"
        searchVC.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "plus.square.on.square.fill"), tag: 1)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        customizeTabBar()
        tabBar.viewControllers = [createSearchNavController(),createFavNavController()]
        return tabBar
    }
    
    func customizeTabBar() {
        UITabBar.appearance().tintColor = .systemGreen
    }
    
    func setupConstraints(){
//        appNavigationTabBar.tabBar.translatesAutoresizingMaskIntoConstraints = false
//        appNavigationTabBar.tabBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        appNavigationTabBar.tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        appNavigationTabBar.tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        appNavigationTabBar.tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
