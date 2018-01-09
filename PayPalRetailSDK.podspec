Pod::Spec.new do |s|
  s.name             = "PayPalRetailSDK"
  s.version          = "3.0.4.20181"
  s.summary          = "SDK for interfacing with PayPal card readers and mobile payment processing APIs."
  s.license          = "COMMERCIAL"
  s.authors          = {"PayPal"=>"DL-PP-RetailSDK@paypal.com"}
  s.homepage         = "https://github.com/PayPal-Mobile/paypal-retail-sdk"
  s.description      = "Retail SDK"
  s.source           = { :git => 'https://github.com/PayPal-Mobile/ios-here-sdk-dist.git', :branch => "master" }

  s.requires_arc = true
  s.ios.deployment_target    = '8.1'

  s.ios.frameworks = 'AudioToolbox', 'MobileCoreServices', 'Security', 'CFNetwork', 'AVFoundation', 'ExternalAccessory', 'MediaPlayer', 'CoreTelephony', 'Foundation', 'CoreBluetooth', 'SystemConfiguration', 'JavaScriptCore', 'CoreBluetooth', 'UIKit', 'CoreLocation'

  s.default_subspec = 'Debug'

  s.subspec 'Debug' do |sp|
    sp.vendored_frameworks      = 'RSDK/Debug/PayPalRetailSDK.framework', 'frameworks/G4XSwiper.framework', 'frameworks/RUA_BLE.framework', 'frameworks/LandiSDK_BLE.framework'
    sp.ios.preserve_paths       = 'RSDK/Debug/PayPalRetailSDK.framework'
    sp.ios.public_header_files  = 'RSDK/Debug/PayPalRetailSDK.framework/Versions/A/Headers/*.h'
    sp.ios.resource             = 'RSDK/Debug/PayPalRetailSDK.framework/Versions/A/Resources/**/*'
  end

  s.subspec 'Release' do |sp|
    sp.vendored_frameworks      = 'RSDK/Release/PayPalRetailSDK.framework', 'frameworks/G4XSwiper.framework', 'frameworks/RUA_BLE.framework', 'frameworks/LandiSDK_BLE.framework'
    sp.ios.preserve_paths       = 'RSDK/Release/PayPalRetailSDK.framework'
    sp.ios.public_header_files  = 'RSDK/Release/PayPalRetailSDK.framework/Versions/A/Headers/*.h'
    sp.ios.resource             = 'RSDK/Release/PayPalRetailSDK.framework/Versions/A/Resources/**/*'
  end

  s.dependency 'SimpleKeychain', '~> 0.6.1'

end