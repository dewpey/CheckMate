source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'Koloda_Example' do
  pod "Koloda", :path => "../"
  pod "stellar-ios-mac-sdk"
  pod "SCLAlertView"
  pod "SwiftSpinner"
  pod 'FontAwesome.swift'
  pod "GTProgressBar"
end

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
