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
        
        let tapBarRouter = TapBarRouter()
        window.rootViewController = tapBarRouter.createTapBarController()
        window.makeKeyAndVisible()
        self.window = window
    }


}

