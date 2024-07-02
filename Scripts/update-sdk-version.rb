require_relative 'sdk_utilities'
require_relative 'sdk_constants'

template_builder = TemplateBuilder.new(
	SquareMobilePaymentsSDK::VERSION,
	SquareMobilePaymentsSDK::COMMIT_SHA,
	SquareMobilePaymentsSDK::LICENSE,
	SquareMobilePaymentsSDK::HOMEPAGE_URL,
	SquareMobilePaymentsSDK::AUTHORS,
	SquareMobilePaymentsSDK::IOS_DEPLOYMENT_TARGET
)

# Generate README
template_builder.build_and_write('./Scripts/templates/README.md.erb', 'README.md', './')
puts "✅ Updated README"

# Generate SquareMobilePaymentsSDK Podsepc
template_builder.build_and_write('./Scripts/templates/SquareMobilePaymentsSDK.podspec.erb', 'SquareMobilePaymentsSDK.podspec', './')
puts "✅ Updated SquareMobilePaymentsSDK.podspec"

# Generate MockReaderUI Podspec
template_builder.build_and_write('./Scripts/templates/MockReaderUI.podspec.erb', 'MockReaderUI.podspec', './')
puts "✅ Updated MockReaderUI.podspec"

# Generate Package.swift
template_builder.build_and_write('./Scripts/templates/Package.swift.erb', 'Package.swift', './')
puts "✅ Updated Package.swift"
