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
    let imageURL: String
    let duration: Int
    let openURL: URL?
    
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
    
    public func showImage(launchImage: LaunchImage?, openURLHandler: @escaping (URL) -> Bool) {
        guard let launchImage = launchImage else {
            showLaunchScreen(image: nil, duration: 2, openURL: nil, openURLHandler: nil)
            return
        }
        
        guard let storage = storage else { return }
        if let image = storage.imageFromCache(withURL: launchImage.imageURL) {
            showLaunchScreen(image: image, duration: launchImage.duration, openURL: launchImage.openURL, openURLHandler: openURLHandler)
        } else  {
            storage.downloadImageAndCached(withURL: launchImage.imageURL, completed: { [weak self] isSuccess in
                guard isSuccess else { return }
                self?.lastCachedLaunchImage = launchImage
            })
            if let lastCachedLaunchImage = lastCachedLaunchImage,
                let image = storage.imageFromCache(withURL: lastCachedLaunchImage.imageURL) {
                showLaunchScreen(image: image, duration: lastCachedLaunchImage.duration, openURL: lastCachedLaunchImage.openURL, openURLHandler: openURLHandler)
            }
        }
    }
    
    private func showLaunchScreen(image: UIImage?, duration: Int, openURL: URL?, openURLHandler: ((URL) -> Bool)?) {
        guard duration > 0 else { return }
        let launchImage = LaunchScreen.LaunchImage(sloganImage: sloganImage, image: image, duration: duration, openURL: openURL)
        let controller = LaunchScreen.initFromStoryboard()
        controller.launchImage = launchImage
        controller.openURLHandler = openURLHandler
        controller.show()
    }
}
