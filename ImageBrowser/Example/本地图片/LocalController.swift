//
//  LocalController.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/16.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

import UIKit

class LocalController: UIViewController {
    static let margin: CGFloat = 10.0
    
    private lazy var collectionView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        
        
        flowLayout.itemSize = CGSize(width: (self.view.bounds.size.width - 3*LocalController.margin) / 2, height: (self.view.bounds.size.height - 64.0 - 6*LocalController.margin) / 5)
        flowLayout.minimumLineSpacing = LocalController.margin
        flowLayout.minimumInteritemSpacing = LocalController.margin
        flowLayout.sectionInset = UIEdgeInsetsZero
        
        
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 64.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64.0), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = false
        collectionView.registerClass(TestCell.self, forCellWithReuseIdentifier: String(TestCell))
        
        return collectionView
    }()
    var photoModels: [PhotoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var images: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!
    ]
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LocalController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TestCell), forIndexPath: indexPath) as! TestCell
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (index, image) in images.enumerate() {
//            这个方法只能返回可见的cell, 如果不可见, 返回值为nil
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TestCell
                let sourceView = cell?.imageView

                let photoModel = PhotoModel(localImage: image, sourceImageView: sourceView, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        
        let testVc = PhotoBrowser(photoModels: setPhoto())
        testVc.showWithBeginPage(indexPath.row)
    }
    
}
