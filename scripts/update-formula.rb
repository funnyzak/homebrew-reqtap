#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require 'openssl'
require 'uri'
require 'digest'

# Update script for reqtap Homebrew formula
# This script fetches the latest release information from GitHub
# and updates the formula file with new URLs and checksums

class FormulaUpdater
  GITHUB_API = 'https://api.github.com/repos/funnyzak/reqtap/releases/latest'
  FORMULA_PATH = File.join(__dir__, '..', 'Formula', 'reqtap.rb')

  def initialize
    @release_data = nil
    @formula_content = nil
  end

  def run
    puts '🚀 Starting reqtap formula update process...'

    # Fetch latest release data
    fetch_release_data

    # Read current formula
    read_formula

    # Update formula with new data
    update_formula

    # Validate updated formula
    validate_formula

    puts '✅ Formula updated successfully!'
  rescue StandardError => e
    puts "❌ Error updating formula: #{e.message}"
    exit 1
  end

  private

  def fetch_release_data
    puts '📡 Fetching latest release data from GitHub...'

    uri = URI(GITHUB_API)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    response = http.get(uri)
    unless response.is_a?(Net::HTTPSuccess)
      raise "Failed to fetch release data: #{response.code} #{response.message}"
    end

    @release_data = JSON.parse(response.body)
    puts "📦 Latest release: #{@release_data['tag_name']}"
  end

  def read_formula
    puts '📖 Reading current formula...'

    unless File.exist?(FORMULA_PATH)
      raise "Formula file not found: #{FORMULA_PATH}"
    end

    @formula_content = File.read(FORMULA_PATH)
  end

  def update_formula
    puts '✏️ Updating formula with new release data...'

    # Update version
    version = @release_data['tag_name']
    @formula_content = @formula_content.gsub(/version "[^"]+"/, %(version "#{version}"))

    # Find macOS assets
    macos_assets = find_macos_assets

    # Update Intel (amd64) version
    update_asset('on_intel do', macos_assets['amd64'])

    # Update Apple Silicon (arm64) version
    update_asset('on_arm do', macos_assets['arm64'])

    # Update default URL (Intel)
    default_asset = macos_assets['amd64']
    @formula_content = @formula_content.gsub(
      /url "[^"]*reqtap-darwin-amd64[^"]*"/,
      %(url "#{default_asset[:url]}")
    )
    @formula_content = @formula_content.gsub(
      /sha256 "[^"]*"/,
      %(sha256 "#{default_asset[:sha256]}")
    )

    # Write updated formula
    File.write(FORMULA_PATH, @formula_content)
    puts '💾 Formula file updated'
  end

  def find_macos_assets
    puts '🔍 Finding macOS assets...'

    assets = {}

    @release_data['assets'].each do |asset|
      name = asset['name']

      if name.include?('darwin-amd64')
        assets['amd64'] = {
          url: asset['browser_download_url'],
          sha256: clean_digest(asset['digest'])
        }
      elsif name.include?('darwin-arm64')
        assets['arm64'] = {
          url: asset['browser_download_url'],
          sha256: clean_digest(asset['digest'])
        }
      end
    end

    unless assets['amd64'] && assets['arm64']
      raise 'Required macOS assets not found in release'
    end

    puts "📋 Found assets for Intel (amd64) and Apple Silicon (arm64)"
    assets
  end

  def update_asset(block_name, asset)
    return unless asset

    # Find the start and end of the block
    start_idx = @formula_content.index(block_name)
    return unless start_idx

    end_idx = find_block_end(start_idx)
    return unless end_idx

    # Extract and update the block
    block_content = @formula_content[start_idx..end_idx]

    # Update URL
    block_content = block_content.gsub(
      /url "[^"]*"/,
      %(url "#{asset[:url]}")
    )

    # Update SHA256
    block_content = block_content.gsub(
      /sha256 "[^"]*"/,
      %(sha256 "#{asset[:sha256]}")
    )

    # Replace the block in the formula
    @formula_content = @formula_content[0...start_idx] + block_content + @formula_content[end_idx + 1..]

    puts "🔄 Updated #{block_name} block"
  end

  def clean_digest(digest)
    return nil if digest.nil?

    # Remove "sha256:" prefix if present
    digest.sub(/^sha256:/, '')
  end

  def find_block_end(start_idx)
    # Find the end of the block by looking for the next "on_" or end of class
    remaining = @formula_content[start_idx..]

    # Look for the end keyword followed by a newline
    end_match = remaining.match(/\n\s*end\s*\n/)
    return nil unless end_match

    start_idx + end_match.begin(0) + end_match[0].length - 1
  end

  def validate_formula
    puts '🔍 Validating updated formula...'

    # Check if the formula has valid Ruby syntax
    require 'tempfile'

    Tempfile.create(['reqtap_test', '.rb']) do |temp_file|
      temp_file.write(@formula_content)
      temp_file.flush

      # Try to parse the Ruby syntax
      result = system("ruby -c #{temp_file.path} > /dev/null 2>&1")
      unless result
        raise 'Formula has invalid Ruby syntax'
      end
    end

    puts '✅ Formula syntax is valid'

    # Check if all required fields are present
    required_patterns = [
      /desc\s+".+"/,
      /homepage\s+".+"/,
      /url\s+".+"/,
      /sha256\s+".+"/,
      /version\s+".+"/,
      /on_intel\s+do/,
      /on_arm\s+do/
    ]

    missing_patterns = required_patterns.reject { |pattern| @formula_content.match?(pattern) }
    unless missing_patterns.empty?
      raise "Formula is missing required fields: #{missing_patterns.join(', ')}"
    end

    puts '✅ All required fields are present'
  end
end

# Run the updater if this script is executed directly
if __FILE__ == $PROGRAM_NAME
  updater = FormulaUpdater.new
  updater.run
end