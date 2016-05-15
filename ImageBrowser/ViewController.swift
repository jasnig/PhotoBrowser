//
//  ViewController.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/3.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class TestCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TestCell), forIndexPath: indexPath) as! TestCell
        let model = photoModels[indexPath.row]
        cell.imageView.kf_setImageWithURL(NSURL(string: model.imageUrlString!)!, placeholderImage: images[0])

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (_, photo) in photoModels.enumerate() {
                // 这个方法只能返回可见的cell, 如果不可见, 返回值为nil
//                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TestCell
//                let sourceView = cell.imageView
//                let photoModel = PhotoModel(localImage: image, sourceImageView: sourceView, description: nil)
                let photoModel = PhotoModel(imageUrlString: photo.imageUrlString, sourceImageView: nil, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        
        let testVc = PhotoBrowser(photoModels: setPhoto())
        testVc.delegate = self
        testVc.showWithBeginPage(indexPath.row)
    }

}

extension ViewController: PhotoBrowserDelegate {
    

    // 将要退出浏览模式
    func photoBrowserWillEndDisplay(endPage: Int) {
        let currentIndexPath = NSIndexPath(forRow: endPage, inSection: 0)
        
        let cell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TestCell
        cell?.alpha = 0.0
    }
    // 已经退出浏览模式
    func photoBrowserDidEndDisplay(endPage: Int) {
        let currentIndexPath = NSIndexPath(forRow: endPage, inSection: 0)
        
        let cell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TestCell
        cell?.alpha = 1.0
    }
    // 正在展示的页, 更新collectionView
    func photoBrowserDidDisplayPage(currentPage: Int, totalPages: Int) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems()
        
        let currentIndexPath = NSIndexPath(forRow: currentPage, inSection: 0)
        if !visibleIndexPaths.contains(currentIndexPath) {
            collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: .Top, animated: false)
        }
    }
    // 获取动态改变的sourceImageView
    func sourceImageViewForCurrentIndex(index: Int) -> UIImageView? {
        
        let currentIndexPath = NSIndexPath(forRow: index, inSection: 0)

        let cell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TestCell
        let sourceView = cell?.imageView
        return sourceView
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!
    ]
    
    var photoModels: [PhotoModel] = []
    @IBAction func slider(sender: UISlider) {
        
    }
    @IBAction func btnOnClick(sender: UIButton) {
        

    }
    
    
    func setupPhoto() {
        
        photoModels =  [
            PhotoModel(imageUrlString: "http://image.tianjimedia.com/uploadImages/2013/134/001GKNRJ7FCO_1440x900.jpg", sourceImageView: imageView1, description: nil),
            PhotoModel(imageUrlString: "http://pic4.nipic.com/20091215/2396136_140959028451_2.jpg", sourceImageView: imageView1, description: nil),
            PhotoModel(imageUrlString: "http://img.taopic.com/uploads/allimg/140326/235113-1403260I33562.jpg", sourceImageView: imageView1, description: nil),
            PhotoModel(imageUrlString: "http://pic1.ooopic.com/uploadfilepic/sheying/2009-01-04/OOOPIC_z19870212_20090104b18ef5b046904933.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://tupian.enterdesk.com/2013/mxy/12/10/15/3.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://image.tianjimedia.com/uploadImages/2011/286/8X76S7XD89VU.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://5.26923.com/download/pic/000/245/718dfc8322abe39627591e4a495767af.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://image.tuwang.com/Nature/FengGuang-1600-1200/FengGuang_pic_abx@DaTuKu.org.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://www.deskcar.com/desktop/fengjing/200895150214/21.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://pic25.nipic.com/20121203/213291_135120242136_2.jpg", sourceImageView: imageView2, description: nil),
            PhotoModel(imageUrlString: "http://image.tianjimedia.com/uploadImages/2012/011/R5J8A0HYL5YV.jpg", sourceImageView: imageView2, description: nil)
            ]

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhoto()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

