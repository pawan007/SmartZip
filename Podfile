# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'SmartZip' do
    
    pod 'MMDrawerController', '~> 0.5.7'
    pod 'ActionSheetPicker-3.0', '~> 2.0.5'
    pod 'Reachability', '~> 3.2'
    pod 'Mixpanel'
    pod 'Crashlytics'
    pod 'CCBottomRefreshControl'
    pod 'UIView+TKGeometry'
    pod 'TTTAttributedLabel'
    pod 'Alamofire', '~> 3.4'
    pod 'Kingfisher', '~> 2.4'
    pod 'SnapKit', '~> 0.21'
    pod 'GoogleAPIClient/Drive', '~> 1.0.2'
    pod 'GTMOAuth2', '~> 1.1.0'
    pod 'SDWebImage', '~>3.7'
    pod 'SSZipArchive'
    pod 'QBImagePickerController'
    pod 'XCGLogger', '~> 3.3'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '2.3'  ## or '3.0'
            end
        end
    end
    
end
