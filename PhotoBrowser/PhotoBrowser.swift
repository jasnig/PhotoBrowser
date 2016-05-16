//
//  PhotoBrowserView.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/10.
//
//  PhotoBrowser.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/4.
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

protocol PhotoBrowserDelegate: NSObjectProtocol {
    // 更新当前的sourceImageView
    func sourceImageViewForCurrentIndex(index: Int) -> UIImageView?
    ///  正在显示第几页
    func photoBrowserDidDisplayPage(currentPage: Int, totalPages: Int)
    //  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片
    func photoBrowerWillDisplay(beginPage: Int)
    // 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片
    func photoBrowserWillEndDisplay(endPage: Int)
    func photoBrowserDidEndDisplay(endPage: Int)
}

// 协议扩展, 实现oc协议的optional效果, 当然可以直接在协议前 加上@objc
extension PhotoBrowserDelegate {
    // 更新当前的sourceImageView
    func sourceImageViewForCurrentIndex(index: Int) -> UIImageView? {
        return nil
    }
    ///  正在显示第几页
    func photoBrowserDidDisplayPage(currentPage: Int, totalPages: Int) { }
    //  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片
    func photoBrowerWillDisplay(beginPage: Int) { }
    // 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片
    func photoBrowserWillEndDisplay(endPage: Int) { }
    func photoBrowserDidEndDisplay(endPage: Int) { }
    
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowser.cellID, forIndexPath: indexPath) as! PhotoViewCell
        // 避免出现重用出错的问题
        cell.resetUI()
        let currentModel = photoModels[indexPath.row]
        // 可能在代理方法中重新设置了sourceImageView,所以需要更新当前的sourceImageView
        currentModel.sourceImageView = getCurrentSourceImageView(indexPath.row)
        cell.photoModel = currentModel
        
        // 注意之前直接传了self的一个函数给singleTapAction 造成了循环引用
        cell.singleTapAction = {[unowned self](ges: UITapGestureRecognizer) in
            self.dismiss()
        }
        
        return cell
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 向下取整
        currentIndex = Int(scrollView.contentOffset.x / scrollView.zj_width + 0.5)

    }

}


class PhotoBrowser: UIView {
    /// 每一页之间的间隔
    static let contentMargin: CGFloat = 20.0
    /// cell重用id
    static let cellID = "cellID"
    
    private var toolBarStyle: ToolBarStyle!
    /// 用来记录当前的图片索引 默认为0 这里设置为-1 是为了在进来的时候设置初始为0也能使oldValue != currentIndex
    private var currentIndex: Int = -1 {
        didSet {
            if oldValue == currentIndex { return }
            
            setupToolBarIndexText(currentIndex)
            // 正在显示的页
            delegate?.photoBrowserDidDisplayPage(currentIndex, totalPages: photoModels.count)
            
        }
    }
    
    private var photoModels: [PhotoModel]
    
    /// 当前的sourceImageView, 以便于设置默认图片和执行动画退出
    private func getCurrentSourceImageView(index: Int) -> UIImageView {
        // 更新当前的sourceImageView, 以便于执行动画退出
        let currentModel = photoModels[index]
        if let sourceView = delegate?.sourceImageViewForCurrentIndex(index) { // 首先判断是否实现了代理方法返回sourceImageView, 如果有,就使用代理返回的
            return sourceView
        } else {// 代理没有返回 就判断是否一开始就设置了sourceImageView
            if let sourceView = currentModel.sourceImageView { //  初始设置了 就使用
                return sourceView
            } else {// 没有设置, 就设置了sourceImageView为 居中的 宽高都为100 (随便设置的)
                
                let sourceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                sourceImageView.center = self.center
                return sourceImageView
                
            }
        }

    }
    
    weak var delegate: PhotoBrowserDelegate?
    
    private lazy var collectionView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        // 每个cell的尺寸  -- 宽度设置为UICollectionView.bounds.size.width ---> 滚一页就是一个完整的cell
        flowLayout.itemSize = CGSize(width: self.zj_width + PhotoBrowser.contentMargin, height: self.zj_height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsZero
        
        // 分页每次滚动 UICollectionView.bounds.size.width
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.zj_width + PhotoBrowser.contentMargin, height: self.zj_height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.registerClass(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoBrowser.cellID)
        self.insertSubview(collectionView, atIndex: 0)
        
        return collectionView
    }()
    
    private lazy var toolBar: PhotoToolBar = {
        
        let toolBar = PhotoToolBar(frame: CGRect(x: 0.0, y: self.zj_height - 44.0, width: self.zj_width, height: 44.0), toolBarStyle: ToolBarStyle())
        self.addSubview(toolBar)
        return toolBar
    }()
    private lazy var hud: SimpleHUD! = {[unowned self] in
        
        let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (self.zj_height - 80)*0.5, width: self.zj_width, height: 80.0))
        return hud
    }()
    
    ///  用于设置当前的页
    ///
    ///  - parameter currentIndex: 指定的页数
    ///  - parameter animated:     是否执行动画滚动到指定的页
    func currentIndex(currentIndex: Int, animated: Bool) {
        assert(currentIndex >= 0 && currentIndex < photoModels.count, "设置的下标有误")
        if currentIndex < 0 || currentIndex >= photoModels.count { return }
        // 更新当前下标
        self.currentIndex = currentIndex
        // 滚动到特定的位置  !----> 这里一定要使用collectionView.bounds.size.width来设置偏移量
        collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * collectionView.zj_width, y: 0.0), animated: animated)
        
    }
    
    private func commonSet() {
        // 背景色
        backgroundColor = UIColor.blackColor()
        // 背景色同时触发懒加载
        collectionView.backgroundColor = UIColor.blackColor()
        toolBar.backgroundColor = UIColor.clearColor()
        
        // 设置ToolBar内容
        setupToolBarAction()
        // 设置toolBar action
        setupToolBarIndexText(currentIndex)
    }
    
    init(photoModels: [PhotoModel]) {
        self.photoModels = photoModels
        let frame = UIApplication.sharedApplication().keyWindow!.bounds
        super.init(frame: frame)
        commonSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }

    
}

// MARK: - toolBar
extension PhotoBrowser {
    
    func setupToolBarIndexText(index: Int) {
        toolBar.indexText = "\(index + 1)/\(photoModels.count)"

    }
    
    func setupToolBarAction() {
        
        toolBar.saveBtnOnClick = {[unowned self] (saveBtn: UIButton) in
            // 保存到相册
            let currentCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoViewCell
            guard let currentImage = currentCell.imageView.image else { return }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
            })
            
        }
        //        toolBar.extraBtnOnClick = {[unowned self] (extraBtn: UIButton) in
        //
        //
        //        }
        
        
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) {
        
        addSubview(hud)
        if error == nil {
            // successful
            hud.showHUD("保存成功!", autoHide: true, afterTime: 1.0)
            
        } else {
            // failure
            hud.showHUD("保存失败!", autoHide: true, afterTime: 1.0)

        }
    }
}

// MARK: - animation
extension PhotoBrowser {
    
    
    func animateZoomIn() {
        
        let currentModel = photoModels[currentIndex]
        let sourceImageView = getCurrentSourceImageView(currentIndex)
        //  当前的sourceView 将它的frame从它的坐标系转换为self的坐标系中来
        let beginFrame = sourceImageView.convertRect(sourceImageView.frame, toView: self)
        
        print(beginFrame)
        
        let sourceViewSnap = snapView(sourceImageView)
        //
        sourceViewSnap.frame = beginFrame
        
        var endBounds: CGRect
        
        if let localImage = currentModel.localImage {
            // 按照图片比例设置imageView的frame
            let width = localImage.size.width < self.zj_width ? localImage.size.width : self.zj_width
            let height = localImage.size.height * (width / localImage.size.width)
            endBounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        } else {
            if let placeholderImage = sourceImageView.image {
                // 按照图片比例设置imageView的frame
                let width = placeholderImage.size.width < self.zj_width ? placeholderImage.size.width : self.zj_width
                let height = placeholderImage.size.height * (width / placeholderImage.size.width)
                endBounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)

            } else {
                endBounds = CGRectZero
            }
        }

        addSubview(sourceViewSnap)
        collectionView.alpha = 0.0
        toolBar.alpha = 0.0
        // 将要进入浏览模式
        delegate?.photoBrowerWillDisplay(currentIndex)
        UIView.animateWithDuration(0.5, animations: {[unowned self] in
            
            sourceViewSnap.bounds = endBounds
            sourceViewSnap.center = self.center
            self.toolBar.alpha = 1.0
        }) {[unowned self] (_) in
            self.collectionView.alpha = 1.0

            sourceViewSnap.removeFromSuperview()
            
        }
    }
    
    func animateZoomOut() {
        
        self.alpha = 0.0
        
        // 当前的cell一定可以获取到
        let currentCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoViewCell
        let currentImageView = currentCell.imageView
        let currentImageSnap = snapView(currentImageView)
        
        
        let window = UIApplication.sharedApplication().keyWindow!
        window.addSubview(currentImageSnap)
        let beginFrame = window.convertRect(currentImageView.frame, toView: window)
//        print(beginFrame)
        currentImageSnap.frame = beginFrame
        
        let sourceImageView = getCurrentSourceImageView(currentIndex)

        let endFrame = sourceImageView.convertRect(sourceImageView.frame, toView: window)
        print(endFrame)
        // 将要退出
        delegate?.photoBrowserWillEndDisplay(currentIndex)
        
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 30, options: [.CurveEaseInOut], animations: {
            
            currentImageSnap.frame = endFrame

        }) {[unowned self] (_) in
            // 退出浏览模式
            self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
            self.removeFromSuperview()
            currentImageSnap.removeFromSuperview()
        }

//        UIView.animateWithDuration(0.25, animations: {
//            currentImageSnap.frame = endFrame
////            currentImageSnap.bounds = CGRect(x: 0.0, y: 0.0, width: endFrame.width, height: endFrame.height)
////            
////            currentImageSnap.transform = CGAffineTransformMakeScale(scaleW, scaleH)
////            currentImageSnap.zj_x = endFrame.origin.x
////            currentImageSnap.zj_y = endFrame.origin.y
//            
////            currentImageSnap.center = CGPoint(x: endFrame.midX, y: endFrame.midY)
//            }) {[unowned self] (_) in
//                self.removeFromSuperview()
//                currentImageSnap.removeFromSuperview()
//        }
    }
    
    func snapView(view: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        return imageView
    
    }
    
    func showWithBeginPage(beginPage: Int) {
        //设置当前
        currentIndex(beginPage, animated: false)
        
        let window = UIApplication.sharedApplication().keyWindow!
        window.addSubview(self)

        animateZoomIn()

    }
    
    
    func dismiss() {
        animateZoomOut()
    }
}


