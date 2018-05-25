//
//  AppDelegate.swift
//  LaunchScreen
//
//  Created by wangxiaotao on 05/23/2018.
//  Copyright (c) 2018 wangxiaotao. All rights reserved.
//

import UIKit
import LaunchScreen
import Kingfisher

class LaunchImageStorage: LaunchImageStorageType {
    
    func downloadImageAndCached(withURL urlString: String, completed: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(false)
            return
        }
        ImageDownloader.default.downloadImage(with: url, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, _, _, _) in
            if let image = image {
                ImageCache.default.store(image, forKey: urlString)
            }
            completed(image != nil)
        }
    }

    func imageFromCache(withURL urlString: String) -> UIImage? {
        return ImageCache.default.retrieveImageInDiskCache(forKey: urlString) ?? ImageCache.default.retrieveImageInMemoryCache(forKey: urlString)
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("iApp.shared.isLatestVersion = \(iApp.shared.isLatestVersion)")
        
        LaunchImageManager.shared.storage = LaunchImageStorage()
        LaunchImageManager.shared.sloganImage = UIImage()
        let launchImage = LaunchImage(imageURL: "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png", duration: 3, openURL: URL(string: "dadxxa://tickes/1"))
        LaunchImageManager.shared.showImage(launchImage: launchImage)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL
            guard let host = url?.absoluteURL.host else { return true}
            if host == "oia.saiday.com" {
                
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
        return true
    }

}

