//
//  LaunchImageManager.swift
//  LaunchScreen
//
//  Created by 王小涛 on 2018/5/22.
//  Copyright © 2018年 王小涛. All rights reserved.
//

import UIKit

public protocol LaunchImageStorageType {
    func downloadImageAndCached(withURL: String, completed: @escaping (Bool) -> Void)
    func imageFromCache(withURL: String) -> UIImage?
}

public struct LaunchImage {
    public let imageURL: String
    public let duration: Int
    public let openURL: URL?
    
    public init(imageURL: String, duration: Int, openURL: URL?) {
        self.imageURL = imageURL
        self.duration = duration
        self.openURL = openURL
    }
    
    init?(dictionary : [String: Any]) {
        guard let imageURL = dictionary["imageURL"] as? String,
            let duration = dictionary["duration"] as? Int else { return nil }
        
        let openURL: URL? = {
            if let urlString = dictionary["openURL"] as? String {
                return URL(string: urlString)
            }else {
                return nil
            }
        }()
        
        self.init(imageURL: imageURL, duration: duration, openURL: openURL)
    }
    
    var propertyListRepresentation : [String: Any] {
        return ["imageURL" : imageURL, "duration": duration, "openURL": openURL?.absoluteString ?? ""]
    }
}

public class LaunchImageManager {
    
    public static let shared = LaunchImageManager()
    
    public var sloganImage: UIImage? 
    
    public var storage: LaunchImageStorageType?

    private let lastCachedLaunchImageStoreKey = "LaunchImage_LastCached"
    private var lastCachedLaunchImage: LaunchImage? {
        didSet {
            guard let lastCachedLaunchImage = lastCachedLaunchImage else { return }
            UserDefaults.standard.set(lastCachedLaunchImage.propertyListRepresentation, forKey: lastCachedLaunchImageStoreKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private init() {
        if let value = UserDefaults.standard.object(forKey: lastCachedLaunchImageStoreKey) as? [String: Any] {
            lastCachedLaunchImage = LaunchImage(dictionary: value)
        }
    }
    
    /// 返回的LaunchImage是这一次启动时，真实显示的启动图信息。（参考方案，如果传进来的launchImage里面的图还没有在缓存中，则展示上次缓存的launchImage），所以真实显示的启动图信息可能是传进来的launchImage，也可能是上一次缓存的launchImage
    public func showImage(launchImage: LaunchImage, openURLHandler: @escaping (URL) -> Bool) -> LaunchImage? {
        guard let storage = storage else { return nil}
        if let image = storage.imageFromCache(withURL: launchImage.imageURL) {
            let launchScreenImage = LaunchScreen.LaunchImage(sloganImage: sloganImage, image: image, duration: launchImage.duration, openURL: launchImage.openURL)
            showLaunchScreen(launchImage: launchScreenImage, openURLHandler: openURLHandler)
            return launchImage
        } else  {
            storage.downloadImageAndCached(withURL: launchImage.imageURL, completed: { [weak self] isSuccess in
                guard isSuccess else { return }
                self?.lastCachedLaunchImage = launchImage
            })
            if let lastCachedLaunchImage = lastCachedLaunchImage,
                let image = storage.imageFromCache(withURL: lastCachedLaunchImage.imageURL) {
                let launchScreenImage = LaunchScreen.LaunchImage(sloganImage: sloganImage, image: image, duration: lastCachedLaunchImage.duration, openURL: lastCachedLaunchImage.openURL)
                showLaunchScreen(launchImage: launchScreenImage, openURLHandler: openURLHandler)
                return lastCachedLaunchImage
            }
        }
        return nil
    }
    
    private func showLaunchScreen(launchImage: LaunchScreen.LaunchImage, openURLHandler: @escaping (URL) -> Bool) {
        guard launchImage.duration > 0 else { return }
        let controller = LaunchScreen.initFromStoryboard()
        controller.launchImage = launchImage
        controller.openURLHandler = openURLHandler
        controller.show()
    }
}
