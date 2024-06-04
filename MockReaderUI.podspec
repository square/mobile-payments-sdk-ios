require './podspec_constants'

Pod::Spec.new do |s|
  s.name = 'MockReaderUI'
  s.version = SquareMobilePaymentsSDK::VERSION
  s.license = SquareMobilePaymentsSDK::LICENSE
  s.homepage = SquareMobilePaymentsSDK::HOMEPAGE_URL
  s.authors = SquareMobilePaymentsSDK::AUTHORS
  s.summary = 'Enables developers to build use mock readers for testing the MobilePaymentsSDK'

  s.ios.deployment_target = SquareMobilePaymentsSDK::IOS_DEPLOYMENT_TARGET

  s.source ={ :git => "https://github.com/square/mobile-payments-sdk-ios.git" , :tag => SquareMobilePaymentsSDK::VERSION }

  s.vendored_frameworks = 'MockReaderUI.xcframework'
  s.prepare_command = <<-CMD
                      unzip XCFrameworks/MockReaderUI_#{SquareMobilePaymentsSDK::COMMIT_SHA}.zip
                      CMD

end