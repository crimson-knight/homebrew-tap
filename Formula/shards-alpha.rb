class ShardsAlpha < Formula
  desc "Crystal Shards fork with supply chain compliance, AI assistant config, and AI docs"
  homepage "https://github.com/crimson-knight/shards"
  url "https://github.com/crimson-knight/shards/archive/refs/tags/v2025.11.25.3.tar.gz"
  sha256 "65a95798516262f6803fb8b43cb22657ad04b472c497e399d2a0420a9b2c3e32"
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
