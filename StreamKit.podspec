
Pod::Spec.new do |s|
  s.name         = "StreamKit"
  s.version      = "2.4.0"
  s.summary      = "A streaming programming framework for UIKit."
  s.homepage     = "https://github.com/godL/StreamKit"
  s.license      = "MIT"
  s.author             = { "GodL" => "547188371@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/godL/StreamKit.git", :tag => s.version.to_s }
  s.source_files  = "StreamKit", "StreamKit/StreamKit.h"
  s.public_header_files = 'StreamKit/StreamKit.h'
  s.framework  = "UIKit"
  s.requires_arc = true

  s.subspec 'Core' do |ss|
  ss.source_files = 'StreamKit/Core/*.{h,m}'
  ss.public_header_files = 'StreamKit/Core/*.h'
  ss.dependency 'StreamKit/Marco'
  end

  s.subspec 'Marco' do |ss|
  ss.source_files = 'StreamKit/Marco/*.h'
  ss.public_header_files = 'StreamKit/Marco/*.h'
  end

  s.subspec 'UI' do |ss|
  ss.dependency 'StreamKit/Core'
  ss.public_header_files = 'StreamKit/UI/*.h'
  ss.source_files = 'StreamKit/UI/*.{h,m}'
  end

end
