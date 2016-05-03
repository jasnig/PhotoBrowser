//
//  ImageView.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/3.
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


import UIKit



class ImageView: UIView {


    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.scrollView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.backgroundColor = UIColor.blackColor()
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        pagingEnabled = false
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
//        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.delegate = self
        return scrollView
    }()
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    var singleTapAction: (() -> Void)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupScrollView()
        addGestures()
    }
    
    private func addGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        
        // 允许优先执行doubleTap, 在doubleTap执行失败的时候执行singleTap
        // 如果没有设置这个, 那么将只会执行singleTap 不会执行doubleTap
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        addGestureRecognizer(singleTap)
        addGestureRecognizer(doubleTap)
    }
    
    private func setupScrollView() {
        scrollView.addSubview(imageView)
        addSubview(scrollView)
    }
    
    // 单击手势, 给外界处理
    func handleSingleTap(ges: UITapGestureRecognizer) {
        singleTapAction?()
        print("single---------")
    }
    
    // 双击放大或者缩小至最小
    func handleDoubleTap(ges: UITapGestureRecognizer) {
        print("double---------")
        
    }
    // 每次缩放时就会频繁的调用
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.center = CGPoint(x: scrollView.bounds.size.width * 0.5, y: scrollView.bounds.size.height * 0.5)
//
//
//    }
}

extension ImageView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        // 居中显示图片
        setImageViewToTheCenter()
        
    }
    
    // 居中显示图片
    func setImageViewToTheCenter() {
//        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5 : 0.0
//        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)*0.5 : 0.0
//        
//        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
        // 只在缩放比例小余屏幕的时候才需要调整, 其他时候会自动调整
        // 一定要加上等号!!!
        if (scrollView.bounds.size.width >= scrollView.contentSize.width) {
                print(scrollView.contentSize.width)
            imageView.center = scrollView.center
        }
//        print("\(imageView.center) ----- \(scrollView.center)")
    }
    
}