
Pod::Spec.new do |s|
  s.name         = "StreamKit"
  s.version      = "1.1.5"
  s.summary      = "A streaming programming framework for UIKit."
  s.homepage     = "https://github.com/godL/StreamKit"
  s.license      = "MIT"
  s.author             = { "GodL" => "547188371@qq.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/godL/StreamKit.git", :tag => s.version.to_s }
  s.source_files  = "StreamKit", "StreamKit/**/*.{h,m}"
  s.public_header_files = 'StreamKit/**/*.{h}'
  s.framework  = "UIKit"
  s.requires_arc = true
end
