require_relative '../sdk_validator'

# Validate Podspecs, SPM, and Templated Files
unless Validator.validate_podspecs && Validator.validate_spm_package && Validator.validate_template_files
	puts "❌ Pull Request Validation Failed"
	exit 1
else
	puts "✅ Pull Request Validation Passed"
	exit 0
end
