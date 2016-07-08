#
# Be sure to run `pod lib lint TLRadioButton.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'TLRadioButton'
  s.version          = '0.1.0'
  s.summary          = 'Animated RadioButton for iOS.'

  s.description      = <<-DESC
Animated RadioButton for iOS.
                       DESC

  s.homepage         = 'http://ftp27.ru/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksey Cherepanov' => 'ftp27host@gmail.com' }
  s.source           = { :git => 'https://github.com/ftp27/TLRadioButton', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ftp27host'

  s.ios.deployment_target = '7.0'

  s.source_files = 'TLRadioButton/Classes/**/*'
end
