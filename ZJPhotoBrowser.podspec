Pod::Spec.new do |s|
  s.name        = "ZJPhotoBrowser"
  s.version     = "0.1.0"
  s.summary     = "PhotoBrowser provides an easy way to reach the effect that looking through photos likes the system photo app and also supports rotation"
  s.homepage    = "https://github.com/jasnig/PhotoBrowser"
  s.license     = { :type => "MIT" }
  s.authors     = { "ZeroJ" => "854136959@qq.com" }

  s.requires_arc = true
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source   = { :git => "https://github.com/jasnig/PhotoBrowser.git", :tag => s.version }
  s.framework  = "UIKit"
  s.dependency 'Kingfisher'
  s.source_files = "ImageBrowser/PhotoBrowser/*.swift"
end