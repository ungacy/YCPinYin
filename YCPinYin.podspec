#
# Be sure to run `pod lib lint YCPinYin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCPinYin'
  s.version          = '0.2'
  s.summary          = 'PinYin of chinese inspired by PinYin4Objc.'

  s.description      = <<-DESC
	PinYin of chinese inspired by PinYin4Objc.
	`单贝` => `db#cb#sb#danbei#chanbei#shanbei` or `db#cb#sb` or `danbei#chanbei#shanbei`
                       DESC

  s.homepage         = 'https://github.com/ungacy/YCPinYin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ungacy' => 'ungacy@126.com' }
  s.source           = { :git => 'https://github.com/ungacy/YCPinYin.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ungacy'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YCPinYin/Classes/**/*'
  
  s.resource = ['YCPinYin/Assets/*.plist']

  s.public_header_files = 'YCPinYin/Classes/**/*.h'
  
end
