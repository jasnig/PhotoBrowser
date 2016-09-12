# PhotoBrowser
---
#####providing an easy way to reach the effect that looking through photos likes the system photo app(快速集成图片浏览器, 支持网络, 本地,以及各种手势)

----

##使用示例效果

![网络图片.gif](http://upload-images.jianshu.io/upload_images/1271831-a188a56a9ac4e4be.gif?imageMogr2/auto-orient/strip)
![最终效果.gif](http://upload-images.jianshu.io/upload_images/1271831-f9a69daadeef8e08.gif?imageMogr2/auto-orient/strip)


-----

### 可以简单快速灵活的实现上图中的效果
### 注意, 代码依赖 Kingfisher, 请先在您的项目中添加Kingfisher框架
### attention please PhotoBrowser relys on 'Kingfisher'

---

## Feature
* providing an easy way to reach the effect that looking through photos likes the system photo app
* support rotation

### 书写思路移步
###[简书1](http://www.jianshu.com/p/331c24bd263e)

---

## Requirements

* iOS 8.0+ 
* Xcode 7.3 or above

## Installation

* CocoaPods
add these lines to your project's file 'Podfile'

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

pod 'ZJPhotoBrowser', '~> 0.1.0'

* 直接下载将下载文件的PhotoBrowser文件夹下的文件拖进您的项目中就可以使用了
*  or drag the downloaded file 'PhotoBrowser' to your project

###Usage
---
一. 本地图片使用示例(load local images' example)

	    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        1. 设置photoModels
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (index, image) in images.enumerate() {
		        //  这个方法只能返回可见的cell, 如果不可见, 返回值为nil
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TestCell
                let sourceView = cell?.imageView
				// 在这里设置本地图片的photoModel, 注意指定的sourceImageView是图片的imageView,用来执行动画和设置初始图片
                let photoModel = PhotoModel(localImage: image, sourceImageView: sourceView, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        // 2. 初始化PhotoBrowser
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
        // 3. 设置初始的页数
        photoBrowser.showWithBeginPage(indexPath.row)
    }

----

二. 网络图片使用(load network images' example)

	    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        1. 设置photoModels
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (index, photoURLString) in photosURLString.enumerate() {
                // 这个方法只能返回可见的cell, 如果不可见, 返回值为nil
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TestCell
                let sourceView = cell?.imageView
                
                // 这里设置网络图片的photoModel 注意指定的sourceImageView是图片的imageView,用来执行动画和设置初始图片
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: sourceView, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        // 2. 初始化PhotoBrowser
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
        // 3. 设置初始的页数
        photoBrowser.showWithBeginPage(indexPath.row)
    }
    
 ---
 
 三. 使用代理,动态更新sourceImageView和进行更多的操作(using delegate to do more useful work)
 
 	    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        1. 设置photoModels
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for photoURLString in photosURLString {
                // 初始化不设置sourceImageView,也可以设置, 如果sourceImageView是不需要动态改变的, 那么推荐不需要代理设置sourceImageView
                // 而在代理方法中动态更新,将会覆盖原来设置的sourceImageView
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: nil, description: nil)
                photos.append(photoModel)
            }
            return photos
        }
        // 2. 初始化PhotoBrowser
        let photoBrowser = PhotoBrowser(photoModels: setPhoto())
        // 3. 指定代理
        photoBrowser.delegate = self
        // 4. 设置初始的页数
        photoBrowser.showWithBeginPage(indexPath.row)
    }   
    
    
代理使用示例(the delegate's method use example)
---
    // 正在展示的页
    // 因为通过 collectionView.cellForItemAtIndexPath(currentIndexPath)
    // 这个方法只能获取到当前显示在collectionView中的cell, 否则返回nil,
    // 所以如果是在浏览图片的时候的页数对应的currentIndexPath已经不在collectionView的可见cell范围内
    // 返回的将是nil, 就不能准确的获取到 sourceImageView 
    // 故在每次显示图片的时候判断如果对应的sourceImageView cell已经不可见
    // 那么就更新collectionView的位置, 滚动到相应的cell
    // 当然更新collectionView位置的方法很多, 这里只是示例
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
    
 



####如果对你有帮助,请随手给个star 
####如果你在使用中遇到问题: 可以联系我QQ: 854136959
## License

PhotoBrowser is released under the MIT license. See LICENSE for details.