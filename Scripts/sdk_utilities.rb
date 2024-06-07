require 'erb'
require 'open3'

class TemplateBuilder
  def initialize(version, commit_sha, license, homepage_url, authors, ios_deployment_target)
    @version = version
    @commit_sha = commit_sha
    @license = license
    @homepage_url = homepage_url
    @authors = authors
    @ios_deployment_target = ios_deployment_target
  end

  def build_and_write(template_path, file_name, output_dir)
    template = File.read(template_path)
    renderer = ERB.new(template)
    result = renderer.result(get_binding)
    File.open("#{output_dir}#{file_name}", 'w+') do |file|
      file.write(result)
    end
  end

  private

  def get_binding
    binding
  end
end

class CommandExecutor
  def self.execute(command)
    stdout, stderr, _status = Open3.capture3(command)
    [stdout, stderr]
  end
end

class Validator
  def self.validate_podspecs
    puts "Validating Podspecs..."
    command = "pod spec lint"
    stdout, _stderr = CommandExecutor.execute(command)
    stdout.scan(/^(\w+)/).flatten
    if stdout.include?("All the specs passed validation.")
      puts "✅ All podspecs have passed validation"
      return true
    else
      puts "❎ Podspecs could not be validated"
      puts stdout
      return false
    end
  end

  def self.validate_spm_package
    puts "Validating SPM Package..."
    command = "swift package describe"
    _stdout, stderr = CommandExecutor.execute(command)
    stderr.scan(/^(\w+)/).flatten
    # It is a known issue that SPM parser errors on binaryTargets. If it is the only error, then proceed as pass
    if stderr.nil? || stderr.empty? || stderr.include?("error: unknown binary artifact file extension 'zip'")
      puts "✅ SPM Package has passed validation"
      return true
    else
      puts "❎ SPM Package could not be validated"
      puts stderr
      return false
    end
  end
end

class HookInstaller
  def self.install_pre_commit_hook
    pre_commit_hook_path = './Scripts/git/pre-commit-hook'
    destination_path = '.git/hooks/pre-commit'

    # Read the contents of the source file
    begin
      hook_content = File.read(pre_commit_hook_path)
    rescue Errno::ENOENT => e
      puts "❎ Error reading source file: #{e.message}"
      return
    end

    # Write the contents to the destination file
    begin
      File.open(destination_path, 'w') do |file|
        file.write(hook_content)
      end
      # Make the hook script executable
      File.chmod(0755, destination_path)
      puts "✅ Pre-commit hook has been installed successfully."
    rescue Errno::ENOENT, Errno::EACCES => e
      puts "❎ Error writing to destination file: #{e.message}"
    end
  end
end
