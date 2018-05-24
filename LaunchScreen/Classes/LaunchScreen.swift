//
//  LaunchScreen.swift
//  LaunchScreen
//
//  Created by 王小涛 on 2018/5/22.
//  Copyright © 2018年 王小涛. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sloganImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var sloganImage: UIImage?
    var launchImage: (image: UIImage, duration: Int, openURL: URL?)?
    
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
        
        sloganImageView.image = sloganImage
        
        guard let launchImage = launchImage else { return }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(sender:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.image = launchImage.image
        
        closeButton.setTitle("\(launchImage.duration) 跳过", for: .normal)
        
        downCounter = DownCounter(step: 1, target: self)
        downCounter.start(count: launchImage.duration)
        downCounter.down = { [weak self] left in
            self?.closeButton.setTitle("\(left) 跳过", for: .normal)
        }
        downCounter.done = { [weak self] in
            self?.dismissInWindow()
        }
    }
    
    @IBAction func clickCloseButton(sender: Any) {
        dismissInWindow()
    }
    
    @objc private func tapOnImage(sender: Any) {
        
        guard let openURL = launchImage?.openURL else { return }
        
        dismissInWindow()
        
        if UIApplication.shared.canOpenURL(openURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(openURL)
            }
        } else if !iApp.shared.isLatestVersion {
            showAppUpdateAlertController()
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func show() {
        showInWindow()
    }
    
    private func showAppUpdateAlertController() {
        let controller = UIAlertController(title: "版本升级", message: "您使用的版本过低，无法跳转页面，请升级后再试。", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "暂时不升级", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "立马升级", style: .destructive) { _ in
            iApp.shared.openAppStorePage()
        }
        controller.addAction(action1)
        controller.addAction(action2)
        present(controller, animated: true, completion: nil)
    }
}
