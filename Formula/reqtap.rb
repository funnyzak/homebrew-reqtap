# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.2.4/reqtap-darwin-amd64.tar.gz"
  version "0.2.4"
  sha256 "sha256:7c55bfe6828f644b37163c8d668394d79d9dc0e5305ee2c01513d117deeadb80"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.4/reqtap-darwin-amd64.tar.gz"
    sha256 "sha256:7c55bfe6828f644b37163c8d668394d79d9dc0e5305ee2c01513d117deeadb80"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.4/reqtap-darwin-arm64.tar.gz"
    sha256 "sha256:7c55bfe6828f644b37163c8d668394d79d9dc0e5305ee2c01513d117deeadb80"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end