# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.2.2/reqtap-darwin-amd64.tar.gz"
  version "0.2.2"
  sha256 "sha256:468748a87f211a7fd7dbf4af4636c237f2c35d16ef3331101a75c5547b35f9e5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.2/reqtap-darwin-amd64.tar.gz"
    sha256 "sha256:468748a87f211a7fd7dbf4af4636c237f2c35d16ef3331101a75c5547b35f9e5"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.2/reqtap-darwin-arm64.tar.gz"
    sha256 "sha256:468748a87f211a7fd7dbf4af4636c237f2c35d16ef3331101a75c5547b35f9e5"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end