//
//  SceneDelegate.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Настройка окна приложения
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // Устанавливаем SplashScreenViewController как стартовый
        let splashScreenVC = SplashScreenViewController()
        window?.rootViewController = splashScreenVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Вызывается, когда сцена отключается системой.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Вызывается, когда сцена переходит из неактивного состояния в активное.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Вызывается, когда сцена переходит из активного состояния в неактивное.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Вызывается, когда сцена переходит из фона на передний план.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Вызывается, когда сцена переходит на фон.
    }
}
