//
//  NoSourceImageViewController.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/25.
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

class NoSourceImageViewController: UIViewController {
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
        "http://a.33iq.com/upload/15/08/12/images/14393706299128.jpg",
        "http://pic1a.nipic.com/2008-09-19/200891903253318_2.jpg",
        "http://online.sccnn.com/desk2/1314/1920car_35003.jpg",
        "http://img1qn.moko.cc/2016-04-21/a37f9d54-493f-4352-8b40-f17cb8570e67.jpg",
        "http://image.tianjimedia.com/uploadImages/2015/204/14/736OGPLY9H62_1000x600.jpg",
        "http://a.hiphotos.baidu.com/image/pic/item/f9dcd100baa1cd11daf25f19bc12c8fcc3ce2d46.jpg",
        "http://image.tianjimedia.com/uploadImages/2013/134/001GKNRJ7FCO_1440x900.jpg",
        "http://pic4.nipic.com/20091215/2396136_140959028451_2.jpg",
        "http://www.05927.com/UploadFiles/pic_200910271459213674.jpg",
        "http://a.hiphotos.baidu.com/image/pic/item/43a7d933c895d1438d0b16fc77f082025baf07eb.jpg",
        "http://c.hiphotos.baidu.com/image/pic/item/8b13632762d0f703f3b967030cfa513d2797c5e2.jpg",
        "http://f.hiphotos.baidu.com/image/pic/item/91529822720e0cf3a2cdbc240e46f21fbe09aa33.jpg",
        "http://pic.58pic.com/58pic/11/52/20/45s58PICVat.jpg"
        
        
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
extension NoSourceImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            for photoURLString in photosURLString {
                // 初始化不设置sourceImageView,也可以设置, 如果sourceImageView是不需要动态改变的, 那么推荐不需要代理设置sourceImageView
                // 而在代理方法中动态更新,将会覆盖原来设置的sourceImageView
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
        photoBrowser.show(inVc: self, beginPage: indexPath.row)
    }
}
