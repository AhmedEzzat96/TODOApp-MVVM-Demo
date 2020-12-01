//
//  AppStateManager.swift
//  TODOApp-MVVM-Demo
//
//  Created by Ahmed Ezzat on 02/12/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import UIKit

protocol AppStateManagerProtocol {
    func start(appDelegate: AppDelegateProtocol)
}

class AppStateManager {
    
    // MARK:- AppState Enum
    enum AppState {
        case none
        case auth
        case main
    }
    
    // MARK:- Properties
    var appDelegate: AppDelegateProtocol!
    var mainWindow: UIWindow? {
        return self.appDelegate?.getMainWindow()
    }
    
    var state: AppState = .none {
        willSet(newState) {
            switch newState {
            case .auth:
                switchToAuthState()
            case .main:
                switchToMainState()
            default:
                return
            }
        }
    }
    
    // MARK:- Singleton
    private static let sharedInstance = AppStateManager()
    
    class func shared() -> AppStateManager {
        return AppStateManager.sharedInstance
    }
    
    
    func switchToMainState() {
        let todoListVC = TodoListVC.create()
        todoListVC.delegate = self
        let navigationController = UINavigationController(rootViewController: todoListVC)
        self.mainWindow?.rootViewController = navigationController
    }
    
    func switchToAuthState() {
        let signInVC = SignInVC.create()
        signInVC.delegate = self
        let navigationController = UINavigationController(rootViewController: signInVC)
        self.mainWindow?.rootViewController = navigationController
    }
}


extension AppStateManager: AppStateManagerProtocol {
    func start(appDelegate: AppDelegateProtocol) {
        self.appDelegate = appDelegate
        
        if UserDefaultsManager.shared().token != nil {
            self.state = .main
        } else {
            self.state = .auth
        }
    }
}


extension AppStateManager: AuthNavigationDelegate {
    func showMainState() {
        self.state = .main
    }
}

extension AppStateManager: MainNavigationDelegate {
    func showAuthState() {
        self.state = .auth
    }
}
