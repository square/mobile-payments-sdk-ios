require_relative 'sdk_utilities'
require_relative 'sdk_constants'
require 'fileutils'

class Validator
  def self.validate_podspecs
    puts "Validating Podspecs..."

    # Runs pod spec lint validation
    command = "pod spec lint"
    stdout, stderr = CommandExecutor.execute(command)
    stdout.scan(/^(\w+)/).flatten

    # Validates output
    unless stdout.include?("All the specs passed validation.")
      puts "❌ Podspecs could not be validated"
      puts stdout
      return false
    end

    puts "✅ All podspecs have passed validation"
    return true
  end

  def self.validate_spm_package
    puts "Validating SPM Package..."

    # Resolves all packages in Package.swift
    command = "swift package resolve"
    _stdout, stderr = CommandExecutor.execute(command)
    stderr.scan(/^(\w+)/).flatten

    # Validates output of resolve does not have errors.
    unless stderr.nil? || stderr.empty?
      puts "❌ SPM Package could not be validated"
      puts stderr
      return false
    end

    packages_to_validate = [
      'SquareMobilePaymentsSDK',
      'MockReaderUI'
    ]

    # Validates SPM was able to resolve and extract the xcframeworks
    for package in packages_to_validate do
      unless File.directory?("./.build/artifacts/mobile-payments-sdk-ios/#{package}/#{package}.xcframework")
        puts "❌ SPM was unable to resolve #{package}"
        FileUtils.rm_rf('.build')
        return false
      end
    end

    FileUtils.rm_rf('.build')

    puts "✅ SPM package has passed validation"
    return true
  end

  def self.validate_template_files
    # Creates a temporary directory to write to in the CI
    FileUtils.mkdir_p('tmp')

    # Creates Template Builder
    template_builder = TemplateBuilder.new(
      SquareMobilePaymentsSDK::VERSION,
      SquareMobilePaymentsSDK::COMMIT_SHA,
      SquareMobilePaymentsSDK::LICENSE,
      SquareMobilePaymentsSDK::HOMEPAGE_URL,
      SquareMobilePaymentsSDK::AUTHORS,
      SquareMobilePaymentsSDK::IOS_DEPLOYMENT_TARGET
    )

    files_to_test = [
      'README.md',
      'SquareMobilePaymentsSDK.podspec',
      'MockReaderUI.podspec',
      'Package.swift'
    ]

    # Validates the files found in the root of the repo match the output of the templated form of the file
    for file in files_to_test do
      template_builder.build_and_write("./Scripts/templates/#{file}.erb", file, './tmp/')
      unless FileComparator.compare("./#{file}", "./tmp/#{file}")
        puts "Output of #{file}.erb rendering does not match #{file}."
        puts "Please ensure you are modifying the erb template and not the output file"
        FileUtils.rm_rf('tmp')
        return false
      end
    end

    FileUtils.rm_rf('tmp')

    puts "✅ Template files have passed validation"
    return true
  end
end
