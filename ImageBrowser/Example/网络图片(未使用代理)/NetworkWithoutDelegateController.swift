//
//  NetworkWithoutDelegateController.swift
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

class NetworkWithoutDelegateController: UIViewController {
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
    let photosURLString: [String] = [
        "http://img1.mydrivers.com/img/20140701/25dd8788193d44f3afbadca4bc21b3a7.gif",
        "http://img.zcool.cn/community/01f08155b607c032f875251fc81d45.gif",
        "http://img.taopic.com/uploads/allimg/140326/235113-1403260I33562.jpg",
        "http://img.taopic.com/uploads/allimg/140326/235113-1403260I33562.jpg",
        "http://tupian.enterdesk.com/2013/mxy/12/10/15/3.jpg",
        "http://5.26923.com/download/pic/000/245/718dfc8322abe39627591e4a495767af.jpg",
        "http://pic25.nipic.com/20121203/213291_135120242136_2.jpg"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        

    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NetworkWithoutDelegateController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosURLString.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TestCell), forIndexPath: indexPath) as! TestCell
        let photoUrlString = photosURLString[indexPath.row]
        cell.imageView.kf_setImageWithURL(NSURL(string: photoUrlString)!, placeholderImage: UIImage(named: "1"))
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (index, photoURLString) in photosURLString.enumerate() {
                // 这个方法只能返回可见的cell, 如果不可见, 返回值为nil
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TestCell
                let sourceView = cell?.imageView
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: sourceView, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
        photoBrowser.showWithBeginPage(indexPath.row)
    }
    
}
