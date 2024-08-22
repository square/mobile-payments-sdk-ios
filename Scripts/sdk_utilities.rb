require 'erb'
require 'fileutils'
require 'open3'
require 'net/http'
require 'uri'
require 'digest'

class TemplateBuilder
  def initialize(version, commit_sha, license, homepage_url, authors, ios_deployment_target, cloudfront_domain)
    @version = version
    @commit_sha = commit_sha
    @license = license
    @homepage_url = homepage_url
    @authors = authors
    @ios_deployment_target = ios_deployment_target
    @cloudfront_domain = cloudfront_domain
    @sdk_checksum, @mock_reader_checksum = checksums(@cloudfront_domain, @version, @commit_sha)
  end

  def build_and_write(template_path, file_name, output_dir)
    template = File.read(template_path)
    renderer = ERB.new(template)
    result = renderer.result(binding)
    File.open("#{output_dir}#{file_name}", 'w+') do |file|
      file.write(result)
    end
  end

  def checksums(cloudfront_domain, version, commit_sha)
    SdkDownloader.download_and_return_checksum(cloudfront_domain, version, commit_sha)
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

class SdkDownloader
  class << self
    def download_and_return_checksum(cloudfront_domain, version, commit_sha)
      sdk_url = "https://#{cloudfront_domain}/mpsdk/#{version}/SquareMobilePaymentsSDK_#{commit_sha}.zip"
      mock_reader_url = "https://#{cloudfront_domain}/mpsdk/#{version}/MockReaderUI_#{commit_sha}.zip"

      self.http_download(sdk_url)
      file_content = File.read("t.zip", mode: 'rb')
      sdk_hash = Digest::SHA256.hexdigest(file_content)
      puts "SHA-256 hash: #{sdk_hash}"

      self.http_download(mock_reader_url)
      file_content = File.read("t.zip", mode: 'rb')
      mock_reader_hash = Digest::SHA256.hexdigest(file_content)
      puts "SHA-256 hash: #{mock_reader_hash}"

      FileUtils.rm("t.zip")

      [sdk_hash, mock_reader_hash]
    end

    def http_download(uri, filename: "t.zip")
      url = URI.parse(uri)
      progress = 0
      Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        response_for_size = http.request_head(url)
        size = response_for_size['content-length'].to_f

        puts "Starting download: #{uri}"
        http.request_get(url.path) do |response|
          # This here is only so we can show some progress, files are heavy
          open(filename, 'w') do |f|
            response.read_body do |chunk|
              f.write chunk
              progress += chunk.length
              printf("\rDownloaded: %.2f%%", 100*(progress/size))
            end
          end

        end
      end
      puts "\nDownload Complete"
    end
  end
end
