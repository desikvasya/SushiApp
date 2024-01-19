//
//  SceneDelegate.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 15.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = TabBarController()
        
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
