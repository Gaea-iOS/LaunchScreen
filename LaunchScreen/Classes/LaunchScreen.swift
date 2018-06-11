//
//  LaunchScreen.swift
//  LaunchScreen
//
//  Created by 王小涛 on 2018/5/22.
//  Copyright © 2018年 王小涛. All rights reserved.
//
import UIKit

class LaunchScreen: UIViewController {
    
    struct LaunchImage {
        let sloganImage: UIImage?
        let image: UIImage?
        let duration: Int
        let openURL: URL?
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sloganImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var launchImage: LaunchImage?
    var openURLHandler: ((URL) -> Bool)?
    
    private var downCounter: DownCounter!
    
    static func initFromStoryboard() -> LaunchScreen {
        let podBundle = Bundle(for: LaunchScreen.self)
        let frameworkBundleURL = podBundle.url(forResource: "LaunchScreen", withExtension: "bundle")
        let bundle = Bundle(url: frameworkBundleURL!)

        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: "LaunchScreen") as! LaunchScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let launchImage = launchImage else { return }
        
        sloganImageView.image = launchImage.sloganImage
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(sender:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.image = launchImage.image
        closeButton.isHidden = launchImage.image == nil
        closeButton.setTitle("\(launchImage.duration) 跳过", for: .normal)
        
        if launchImage.duration > 0 {
            downCounter = DownCounter(step: 1, target: self)
            downCounter.start(count: launchImage.duration)
            downCounter.down = { [weak self] left in
                self?.closeButton.setTitle("\(left) 跳过", for: .normal)
            }
            downCounter.done = { [weak self] in
                self?.dismissInWindow()
            }
        }
    }
    
    @IBAction func clickCloseButton(sender: Any) {
        dismissInWindow()
    }
    
    @objc private func tapOnImage(sender: Any) {
        
        guard let launchImage = launchImage, let openURL = launchImage.openURL, let openURLHandler = openURLHandler else { return }
        
        dismissInWindow()
        
        _ = openURLHandler(openURL)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func show() {
        showInWindow()
    }
}
