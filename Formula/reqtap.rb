# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.3.8/reqtap-darwin-amd64.tar.gz"
  version "0.3.8"
  sha256 "dc23e90d6e4ef6e9ca682a75d7d39cdc7fe949361a5be80285d9748b6c7c6005"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.8/reqtap-darwin-amd64.tar.gz"
    sha256 "dc23e90d6e4ef6e9ca682a75d7d39cdc7fe949361a5be80285d9748b6c7c6005"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.8/reqtap-darwin-arm64.tar.gz"
    sha256 "824ff4a3dbbc50d7472b7ff7e52f53e835d63db15780de8516321877c9b71a88"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end