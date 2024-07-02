require 'erb'
require 'fileutils'
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

class FileComparator
  def self.compare(file1_path, file2_path)
    unless File.exist?(file1_path) && File.exist?(file2_path)
      puts "File at #{file1_path} or at #{file2_path} does not exist."
      return false
    end

    unless FileUtils.identical?(file1_path, file2_path)
      return false
    end

    return true
  end
end
