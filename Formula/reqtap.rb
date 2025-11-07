# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Reqtap < Formula
  desc "A powerful HTTP request debugging tool built in Go"
  homepage "https://github.com/funnyzak/reqtap"
  url "https://github.com/funnyzak/reqtap/releases/download/0.2.0/reqtap-darwin-amd64.tar.gz"
  version "0.2.0"
  sha256 "cde3d40982d77256b8dc857796dd0a540e479423b1b9b95b3536c23c14912fb6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_intel do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.0/reqtap-darwin-amd64.tar.gz"
    sha256 "cde3d40982d77256b8dc857796dd0a540e479423b1b9b95b3536c23c14912fb6"
  end

  on_arm do
    url "https://github.com/funnyzak/reqtap/releases/download/0.2.0/reqtap-darwin-arm64.tar.gz"
    sha256 "788173bbc756f04bafd305636cc603d650c91f83677cd5b11370eb8953980c7b"
  end

  def install
    bin.install "reqtap"
  end

  test do
    system "#{bin}/reqtap --version"
  end
end