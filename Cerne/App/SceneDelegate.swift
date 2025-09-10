//
//  SceneDelegate.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let quickActionService = (UIApplication.shared.delegate as? AppDelegate)?.quickActionService
        quickActionService?.selectedAction = QuickActionEnum(rawValue: shortcutItem.type)
        completionHandler(true)
    }
}
