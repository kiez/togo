inhibit_all_warnings!

pod 'ReactiveCocoa', '~> 2.3'
pod 'AFNetworking', '~> 2.2.4'
pod 'Foursquare-API-v2', '~> 1.4'

# Error handling via responder chain
pod 'ErrorKit/Core'
pod 'ErrorKit/UIKit'
pod 'ErrorKit/CoreData'
pod 'ErrorKit/HTTP'

pod 'Tweaks'
pod 'pop'

pod 'iOS-KML-Framework', :git => 'https://github.com/FLCLjp/iOS-KML-Framework.git'
pod 'Reveal-iOS-SDK'

pod 'IGHTMLQuery', '~> 0.8.1' ## HTML Parsing

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end