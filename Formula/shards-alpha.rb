class ShardsAlpha < Formula
  desc "Crystal Shards fork with supply chain compliance, AI assistant config, and AI docs"
  homepage "https://github.com/crimson-knight/shards"
  url "https://github.com/crimson-knight/shards/archive/refs/tags/v2025.11.25.5.tar.gz"
  version "2025.11.25.5"
  sha256 "935c902e887a562f914d44523a9b307ea6d8b0937b1279e5a2946c0f63a94b85"
  license "Apache-2.0"

  depends_on "crystal"

  def install
    system "make", "bin/shards-alpha", "release=1"
    bin.install "bin/shards-alpha"
  end

  test do
    assert_match "Shards Alpha", shell_output("#{bin}/shards-alpha --version")
  end
end
