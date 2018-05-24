//
//  UIViewController+UIWindow.swift
//  LaunchScreen
//
//  Created by 王小涛 on 2018/5/24.
//

import Foundation

class JRWindowsManager {
    
    static let shared = JRWindowsManager()
    private var windows: [UIWindow] = []
    
    func add(window: UIWindow) {
        windows.append(window)
    }
    
    func remove(window: UIWindow) {
        if let index = windows.index(of: window) {
            windows.remove(at: index)
        }
    }
}

extension UIViewController {
    
    private static var previousWindowAssociatedObjectKey = "previousWindowAssociatedObjectKey"
    
    private var previousWindow: UIWindow? {
        get {
            
            return objc_getAssociatedObject(self, &UIViewController.previousWindowAssociatedObjectKey) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.previousWindowAssociatedObjectKey, previousWindow, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func showInWindow(windowLevel: UIWindowLevel = UIWindowLevelAlert + 1) {
        previousWindow = UIApplication.shared.keyWindow
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = windowLevel
        window.rootViewController = self
        window.makeKeyAndVisible()
        JRWindowsManager.shared.add(window: window)
    }
    
    public func dismissInWindow() {
        guard let window = view.window else { return }
        previousWindow?.makeKeyAndVisible()
        JRWindowsManager.shared.remove(window: window)
    }
}
