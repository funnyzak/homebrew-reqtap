# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.3.5/reqtap-darwin-amd64.tar.gz"
  version "0.3.5"
  sha256 "sha256:ed83ad84493277aeba7b5308ba5310cc78412c628f302dbce4d35c397339a95f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.5/reqtap-darwin-amd64.tar.gz"
    sha256 "sha256:ed83ad84493277aeba7b5308ba5310cc78412c628f302dbce4d35c397339a95f"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.3.5/reqtap-darwin-arm64.tar.gz"
    sha256 "sha256:ed83ad84493277aeba7b5308ba5310cc78412c628f302dbce4d35c397339a95f"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end