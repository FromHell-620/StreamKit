
Pod::Spec.new do |s|
  s.name         = "StreamKit"
  s.version      = "1.4.8"
  s.summary      = "A streaming programming framework for UIKit."
  s.homepage     = "https://github.com/godL/StreamKit"
  s.license      = "MIT"
  s.author             = { "GodL" => "547188371@qq.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/godL/StreamKit.git", :tag => s.version.to_s }
  s.source_files  = "StreamKit", "StreamKit/StreamKit.h"
  s.public_header_files = 'StreamKit/StreamKit.h'
  s.framework  = "UIKit"
  s.requires_arc = true

  s.subspec 'ReactiveX' do |ss|
  ss.source_files = 'StreamKit/Reactive/*.{h,m}'
  ss.public_header_files = 'StreamKit/Reactive/*.h'
  ss.dependency 'StreamKit/Marco'
  ss.dependency 'StreamKit/NSObject'
  ss.dependency 'StreamKit/UIView'
  ss.dependency 'StreamKit/UIGestureRecognizer'
  ss.dependency 'StreamKit/UIScrollView'
  end

  s.subspec 'Marco' do |ss|
  ss.source_files = 'StreamKit/Marco/*.h'
  ss.public_header_files = 'StreamKit/Marco/*.h'
  end

  s.subspec 'NSObject' do |ss|
  ss.dependency 'StreamKit/Marco'
  ss.source_files = 'StreamKit/NSObject/*.{h,m}'
  ss.public_header_files = 'StreamKit/NSObject/*.h'
  end

  s.subspec 'UIGestureRecognizer' do |ss|
  ss.dependency 'StreamKit/NSObject'
  ss.public_header_files = 'StreamKit/UIGestureRecognizer/*.h'
  ss.source_files = 'StreamKit/UIGestureRecognizer/*.{h,m}'
  end

  s.subspec 'UIView' do |ss|
  ss.dependency 'StreamKit/NSObject'
  ss.public_header_files = 'StreamKit/UIView/*.h'
  ss.source_files = 'StreamKit/UIView/*.{h,m}'
  end

  s.subspec 'UIScrollView' do |ss|
  ss.dependency 'StreamKit/NSObject'
  ss.dependency 'StreamKit/UIView'
  ss.public_header_files = 'StreamKit/UIScrollView/*.h'
  ss.source_files = 'StreamKit/UIScrollView/*.{h,m}'
  end

  s.subspec 'UIViewController' do |ss|
  ss.dependency 'StreamKit/NSObject'
  ss.public_header_files = 'StreamKit/UIViewController/*.h'
  ss.source_files = 'StreamKit/UIViewController/*.{h,m}'

  end

end
