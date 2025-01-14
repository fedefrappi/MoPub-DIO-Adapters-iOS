#
# Be sure to run `pod lib lint MoPub-DIO-Adapters.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
    s.name             = 'MoPub-DIO-Adapters'
    s.version          = '1.1.1'
    s.summary          = 'DIO Adapters for mediating through MoPub.'
    s.homepage         = 'https://www.display.io/'
    s.license          = { :type => '', :file => 'LICENSE' }
    s.author           = { 'Ariel Malka' => 'arielm@display.io' }
    s.source           = { :git => "https://github.com/displayio/MoPub-DIO-Adapters-iOS.git", :tag => "#{s.version}"}
    s.ios.deployment_target = '10.0'
    s.static_framework = true
    s.subspec 'MoPub' do |ms|
       ms.dependency 'mopub-ios-sdk/Core', '~> 5.8'
    end
    s.subspec 'Network' do |ns|
        ns.source_files = 'Classes/*.{h,m}'
        ns.dependency 'DIOSDK', '2.3.0'
        ns.dependency 'mopub-ios-sdk/Core', '~> 5.8'
    end
end
