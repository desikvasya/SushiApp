//
//  TabBarController.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 15.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .black
        setupTabBar()
    }
    
    private func setupTabBar() {
        let infoVC = InfoViewController()
        let catalogVC = CatalogViewController()
        let cartVC = CartViewController()
        
        infoVC.tabBarItem = UITabBarItem(title: "",
                                         image: UIImage(systemName: "info"),
                                         selectedImage: nil)
        catalogVC.tabBarItem = UITabBarItem(title: "",
                                            image: UIImage(systemName: "list.bullet"),
                                            selectedImage: nil)
        cartVC.tabBarItem = UITabBarItem(title: "",
                                         image: UIImage(systemName: "bag"),
                                         selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .yellow
        
        self.viewControllers = [catalogVC, cartVC, infoVC].map {
            UINavigationController(rootViewController: $0)
        }
    }
}
