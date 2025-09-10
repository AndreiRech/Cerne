//
//  AppDelegate.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

import UIKit
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    var quickActionService = QuickActionService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let icon = UIApplicationShortcutIcon(systemImageName: "plus.circle")
        
        let shortcutItem = UIApplicationShortcutItem(
            type: "mapTree",
            localizedTitle: "Mapear uma Árvore",
            localizedSubtitle: nil,
            icon: icon,
            userInfo: nil
        )
        
        UIApplication.shared.shortcutItems = [shortcutItem]
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self 

        if let shortcutItem = options.shortcutItem {
            quickActionService.selectedAction = QuickAction(rawValue: shortcutItem.type)
        }
        
        return sceneConfiguration
    }
}
