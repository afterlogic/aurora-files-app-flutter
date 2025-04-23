fvm flutter pub get
fvm flutter build ipa
xcodebuild clean archive -workspace ios/Runner.xcworkspace -scheme Runner -archivePath ios/RunnerArchive -allowProvisioningUpdates
#xcodebuild -exportArchive -archivePath ios/RunnerArchive.xcarchive -exportOptionsPlist ios/ExportOptions.plist -exportPath ./build