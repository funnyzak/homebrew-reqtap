# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.3.0/reqtap-darwin-amd64.tar.gz"
  version "0.3.0"
  sha256 "sha256:59b98b9368a1fee0f793c3589cdae1446a149696f983169993766ddb7eaa8f6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.0/reqtap-darwin-amd64.tar.gz"
    sha256 "sha256:59b98b9368a1fee0f793c3589cdae1446a149696f983169993766ddb7eaa8f6a"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.0/reqtap-darwin-arm64.tar.gz"
    sha256 "sha256:59b98b9368a1fee0f793c3589cdae1446a149696f983169993766ddb7eaa8f6a"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end