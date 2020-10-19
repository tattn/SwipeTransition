Pod::Spec.new do |s|
  s.name             = 'SwipeTransitionAutoSwipeToDismiss'
  s.version          = '0.4.3'
  s.summary          = 'Allows trendy transitions using swipe gesture such as "swipe back".'

  s.description      = <<-DESC
SwipeTransition allows trendy transitions using swipe gesture such as "swipe back".
                       DESC

  s.homepage         = 'https://github.com/tattn/SwipeTransition'
  # s.screenshots      = 'https://github.com/tattn/SwipeTransition/raw/master/docs/assets/demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'git' => 'tanakasan2525@gmail.com' }
  s.source           = { :git => 'https://github.com/tattn/SwipeTransition.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tanakasan2525'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/Automation/AutoSwipeToDismiss/**/*.{swift,h,m}'
  
  s.public_header_files = 'Sources/Automation/AutoSwipeToDismiss/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SwipeTransition', "~> #{s.version.to_s}"
end
