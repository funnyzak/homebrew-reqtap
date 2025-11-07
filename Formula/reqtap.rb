# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.2.1/reqtap-darwin-amd64.tar.gz"
  version "0.2.1"
  sha256 "sha256:0bb2bf437f5e786b9b6052c997a331c83ce390568155093c29efc17edba6f6ba"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.1/reqtap-darwin-amd64.tar.gz"
    sha256 "sha256:0bb2bf437f5e786b9b6052c997a331c83ce390568155093c29efc17edba6f6ba"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.1/reqtap-darwin-arm64.tar.gz"
    sha256 "sha256:0bb2bf437f5e786b9b6052c997a331c83ce390568155093c29efc17edba6f6ba"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end