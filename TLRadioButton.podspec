#
# Be sure to run `pod lib lint TLRadioButton.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'TLRadioButton'
  s.version          = '0.1.2'
  s.summary          = 'Animated RadioButton for iOS.'

  s.description      = <<-DESC
![Sample](https://github.com/ftp27/TLRadioButton/blob/master/TLRadioButton.gif)

Radio button for iOS. 

##Usage

 * _isChecked_ - button status. Default - false
 * _Animation duratoin_ - button animation speed in ms. Default - 500 ms
                       DESC
  s.homepage         = 'https://github.com/ftp27/TLRadioButton'
  s.screenshots      = 'https://github.com/ftp27/TLRadioButton/raw/master/TLRadioButton.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksey Cherepanov' => 'ftp27host@gmail.com' }
  s.source           = { :git => 'https://github.com/ftp27/TLRadioButton.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ftp27host'

  s.ios.deployment_target = '7.0'

  s.source_files = 'TLRadioButton/Classes/**/*'
end
