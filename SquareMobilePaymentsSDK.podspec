require './podspec_constants'

Pod::Spec.new do |s|
  s.name = 'SquareMobilePaymentsSDK'
  s.version = SquareMobilePaymentsSDK::VERSION
  s.license = SquareMobilePaymentsSDK::LICENSE
  s.homepage = SquareMobilePaymentsSDK::HOMEPAGE_URL
  s.authors = SquareMobilePaymentsSDK::AUTHORS
  s.summary = 'Enables developers to build secure in-person payment solutions'

  s.ios.deployment_target = SquareMobilePaymentsSDK::IOS_DEPLOYMENT_TARGET

  s.source ={ :git => "git@github.com:square/mobile-payments-sdk-ios.git", :tag => SquareMobilePaymentsSDK::VERSION }

  s.vendored_frameworks = 'SquareMobilePaymentsSDK.xcframework'
  s.prepare_command = <<-CMD
                      unzip XCFrameworks/SquareMobilePaymentsSDK_#{SquareMobilePaymentsSDK::COMMIT_SHA}.zip
                      CMD

end