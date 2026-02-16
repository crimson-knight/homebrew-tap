class ShardsAlpha < Formula
  desc "Crystal Shards fork with supply chain compliance, AI assistant config, and AI docs"
  homepage "https://github.com/crimson-knight/shards"
  url "https://github.com/crimson-knight/shards/archive/refs/heads/alpha.tar.gz"
  version "2025.11.25.3"
  sha256 "505eec53025efccf3da48f4f7049116a686b624fdb1597986faa1d03da1d692e"
  license "Apache-2.0"

  depends_on "crystal"

  def install
    system "make", "bin/shards-alpha", "release=1"
    bin.install "bin/shards-alpha"
  end

  test do
    assert_match "shards-alpha", shell_output("#{bin}/shards-alpha --version")
  end
end
