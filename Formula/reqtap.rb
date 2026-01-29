# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.3.6/reqtap-darwin-amd64.tar.gz"
  version "0.3.6"
  sha256 "ace8eab7dc1c7dcf89b1e7d13110e35aec86a65e44636befe87c063b7cccdc65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.6/reqtap-darwin-amd64.tar.gz"
    sha256 "ace8eab7dc1c7dcf89b1e7d13110e35aec86a65e44636befe87c063b7cccdc65"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.6/reqtap-darwin-arm64.tar.gz"
    sha256 "ace8eab7dc1c7dcf89b1e7d13110e35aec86a65e44636befe87c063b7cccdc65"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end