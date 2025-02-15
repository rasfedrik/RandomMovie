//
//  SceneDelegate.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let builder = ModuleBuilder.createTapBarController()
//        let navController = UINavigationController(rootViewController: builder)
        window.rootViewController = builder
        window.makeKeyAndVisible()
        self.window = window
    }


}

