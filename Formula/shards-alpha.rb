class ShardsAlpha < Formula
  desc "Crystal Shards fork with supply chain compliance, AI assistant config, and AI docs"
  homepage "https://github.com/crimson-knight/shards"
  url "https://github.com/crimson-knight/shards/archive/refs/tags/v2025.11.25.6.tar.gz"
  version "2025.11.25.6"
  sha256 "e987aa3eb5982f498f6f8a91b24770f31b4dbaab9a78af40d0943624c0fb00b2"
  license "Apache-2.0"

  depends_on "crimson-knight/agent-crystal/agent-crystal" => :build
  depends_on "bdw-gc"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    ENV["CRYSTAL_CACHE_DIR"] = (buildpath/".crystal-cache").to_s
    compiler = Formula["crimson-knight/agent-crystal/agent-crystal"].opt_bin/"acrystal"
    system compiler, "run", "scripts/verify_vendored_dependencies.cr"
    system "make", "bin/shards-alpha", "release=1", "CRYSTAL=#{compiler}",
           "SHARDS_CONFIG_BUILD_COMMIT=2e38fc2"
    bin.install "bin/shards-alpha"
  end

  test do
    assert_match "Shards Alpha 2025.11.25.6", shell_output("#{bin}/shards-alpha --version")
    (testpath/"dependency/.claude/skills/probe").mkpath
    (testpath/"dependency/shard.yml").write("name: docs_probe\nversion: 1.0.0\n")
    payload = testpath/"dependency/.claude/skills/probe/payload.txt"
    payload.write("unchanged upstream payload")
    (testpath/"shard.yml").write <<~YAML
      name: storage_probe
      version: 0.1.0
      dependencies:
        docs_probe:
          path: ./dependency
    YAML
    system bin/"shards-alpha", "install", "--local", "--skip-ai-assistant"
    destination = testpath/".claude/skills/docs_probe--probe/payload.txt"
    timestamp = Time.at(1_700_000_000)
    File.utime(timestamp, timestamp, destination)
    system bin/"shards-alpha", "install", "--frozen", "--local", "--skip-ai-assistant"
    assert_equal timestamp, File.mtime(destination)
    assert_equal payload.read, destination.read
  end
end
