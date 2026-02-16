class ShardsAlpha < Formula
  desc "Crystal Shards fork with supply chain compliance, AI assistant config, and AI docs"
  homepage "https://github.com/crimson-knight/shards"
  url "https://github.com/crimson-knight/shards/archive/refs/heads/alpha.tar.gz"
  version "2025.11.25.3"
  sha256 "b8fd66a9285e76a0a86c16a68ef1b4fc0b7d32d160c746b60a7f2e74afedd7a2"
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
