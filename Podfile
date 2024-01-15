# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'nearFeast' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for nearFeast
pod 'LGSideMenuController','2.1.1'
pod 'IQKeyboardManagerSwift'
pod 'AlamofireImage'
pod 'SwiftyJSON'

pod 'DateToolsSwift'
pod 'NVActivityIndicatorView'
pod 'ReachabilitySwift'
pod 'ChameleonFramework/Swift'

pod 'FBSDKLoginKit'
pod 'GoogleSignIn'

pod 'JGProgressHUD'
pod 'SDWebImage'
pod 'FSPagerView'
pod 'RangeSeekSlider'

pod 'FirebaseCore'
pod 'FirebaseMessaging'
pod 'FirebaseAnalytics'
pod 'FirebaseAuth'
pod 'FirebaseCrashlytics'
pod 'FirebaseStorage'
pod 'FirebaseFirestore'
pod 'FirebaseFirestoreSwift'

pod "AlignedCollectionViewFlowLayout"
pod 'Regift'
pod 'ImageSlideshow/SDWebImage'
pod 'DKChainableAnimationKit'

pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Google-Maps-iOS-Utils'
pod "ExpandableLabel"
pod 'ReadMoreTextView'
pod 'DHExpandableLabel'
pod 'iOSDropDown'
pod 'Cosmos'
pod 'FormTextField'
pod 'Stripe'
pod 'IBAnimatable'
pod 'ExpyTableView'
end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
               end
          end
   end
end
