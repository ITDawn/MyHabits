//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Dany on 07.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UITabBar.appearance().barTintColor = UIColor(patternImage: UIImage(named: "22")!)
        UITabBar.appearance().tintColor = .purple
        UINavigationBar.appearance().tintColor = .purple
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        let blur = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blur)
        visualEffect.frame = CGRect(x: 0, y: 0, width: 768, height: 100)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.layer.cornerRadius = 7
        visualEffect.layer.masksToBounds = true
        let tabBarController = UITabBarController()
        tabBarController.tabBar.addSubview(visualEffect)
        let firstVC = HabitsViewController()
        firstVC.tabBarItem = UITabBarItem(title: "Приввычки", image: UIImage(systemName: "rectangle.grid.1x2.fill"), tag: 0)
        let secondVC = InfoViewController()
        secondVC.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        let firstNavController = UINavigationController(rootViewController: firstVC)
        firstNavController.navigationController?.navigationBar.prefersLargeTitles = true
        let secNavController = UINavigationController(rootViewController: secondVC)
        tabBarController.viewControllers = [firstNavController,secNavController]
        window?.rootViewController = tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

