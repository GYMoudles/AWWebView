#
# Be sure to run `pod lib lint AWWebView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AWWebView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AWWebView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/maltsugar/AWWebView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'maltsugar' => '173678978@qq.com' }
  s.source           = { :git => 'https://github.com/maltsugar/AWWebView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AWWebView/Classes/**/*'
  

  s.resource_bundles = {
      'AWWebView' => ['AWWebView/Classes/**/*.xib', 'AWWebView/Assets/*.xcassets']
  }
  
  s.prefix_header_contents = <<-EOS
  #ifdef __OBJC__
  #import <UIKit/UIKit.h>
  
  #define kAWWebViewBundleName @"AWWebView"
  
  #else
  #ifndef FOUNDATION_EXPORT
  #if defined(__cplusplus)
  #define FOUNDATION_EXPORT extern "C"
  #else
  #define FOUNDATION_EXPORT extern
  #endif
  #endif
  #endif
  EOS
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'WebViewJavascriptBridge'
end
