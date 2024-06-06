require_relative '../sdk_utilities'
require_relative '../sdk_constants'
require 'fileutils'

class FileComparator
  def self.compare(file1_path, file2_path)
    unless File.exist?(file1_path) && File.exist?(file2_path)
      return false
    end

    file1 = File.open(file1_path)
    file2 = File.open(file2_path)

    file1.each_line.zip(file2.each_line) do |line1, line2|
      if line1 != line2
        file1.close
        file2.close
        return false
      end
    end

    file1.close
    file2.close

    true
  end
end

def create_temp_dir
	FileUtils.mkdir_p('tmp')
end

def delete_temp_dir
	FileUtils.rm_rf('tmp')
end

def pass_validation
	puts "✅ Pre-Commit Validation Passed!"
	exit 0
end

def fail_validation
	puts "❎ Pre-Commit Validation Failed. Aborting Commit"
	exit 1
end

create_temp_dir

template_builder = TemplateBuilder.new(
	SquareMobilePaymentsSDK::VERSION,
	SquareMobilePaymentsSDK::COMMIT_SHA,
	SquareMobilePaymentsSDK::LICENSE,
	SquareMobilePaymentsSDK::HOMEPAGE_URL,
	SquareMobilePaymentsSDK::AUTHORS,
	SquareMobilePaymentsSDK::IOS_DEPLOYMENT_TARGET
)

# Generate Temporary README
template_builder.build_and_write('./Scripts/templates/README.md.erb', 'README.md', './tmp/')

# Generate Temporary SquareMobilePaymentsSDK Podsepc
template_builder.build_and_write('./Scripts/templates/SquareMobilePaymentsSDK.podspec.erb', 'SquareMobilePaymentsSDK.podspec', './tmp/')

# Generate Temporary MockReaderUI Podspec
template_builder.build_and_write('./Scripts/templates/MockReaderUI.podspec.erb', 'MockReaderUI.podspec', './tmp/')

# Generate Temporary Package.swift
template_builder.build_and_write('./Scripts/templates/Package.swift.erb', 'Package.swift', './tmp/')

# Validates no changes in the diff between generated files and the files being checked in
if FileComparator.compare('./README.md', './tmp/README.md') &&
	 FileComparator.compare('./SquareMobilePaymentsSDK.podspec', './tmp/SquareMobilePaymentsSDK.podspec') &&
	 FileComparator.compare('./MockReaderUI.podspec', './tmp/MockReaderUI.podspec') &&
	 FileComparator.compare('./Package.swift', './tmp/Package.swift')
	# All files are identical!
	delete_temp_dir
else
	puts "Please ensure you are modifying the erb template and not the actual file"
	delete_temp_dir
	fail_validation
end

# Validate Podspec and Package.swift
if Validator.validate_podspecs && Validator.validate_spm_package
	pass_validation
else
	fail_validation
end
