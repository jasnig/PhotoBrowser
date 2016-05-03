//
//  ViewController.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/3.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testImageView = ImageView(frame: view.bounds)
        view.addSubview(testImageView)
        testImageView.image = UIImage(named: "1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

