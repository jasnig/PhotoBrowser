//
//  ViewController.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/3.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Kingfisher

class TestCell: UICollectionViewCell {
    lazy var imageView: UIImageView = UIImageView(frame: self.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .ScaleToFill
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
  

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

