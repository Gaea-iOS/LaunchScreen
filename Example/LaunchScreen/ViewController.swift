//
//  ViewController.swift
//  LaunchScreen
//
//  Created by wangxiaotao on 05/23/2018.
//  Copyright (c) 2018 wangxiaotao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let r = URLRequest(url: URL(string: "https://m.saiday.com/oiat/1.html")!)
        webView.loadRequest(r)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickButton(sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://oia.saiday.com/topics/5")!)
    }
}

