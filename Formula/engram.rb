class Engram < Formula
  desc "Branch-scoped memory for coding agents — perfect recall on checkout, clean amnesia on switch"
  homepage "https://github.com/crimson-knight/engram"
  url "https://github.com/crimson-knight/engram/archive/refs/tags/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "79a4ed30aa89891f373a2a3a046a8db762867d0fd0dcb8c04e917f9af427bcf3"
  license "MIT"
  # Revision 1 builds with agent-crystal and ships bottles, so `brew upgrade` replaces
  # a copy built with homebrew-core crystal.
  revision 2

  bottle do
    root_url "https://github.com/crimson-knight/homebrew-tap/releases/download/engram-0.2.0_2"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "f4b785cd3048673dedff74862fc2bae5e2797dec4a0942f04d245c3a73105712"
  end

  # Built with the AgentC compiler. The binary links no part of it (the collector
  # is static), so the compiler is needed only to build.
  # Built with agent-crystal 1.22.3-incremental-6 (tap commit c1f592484db8).
  # scripts/sync_downstreams.rb in crimson-knight/homebrew-agent-crystal raises the revision when it moves.
  depends_on "crimson-knight/agent-crystal/agent-crystal" => :build
  # Digest::SHA256 and the embedder's HTTPS client link libssl and libcrypto.
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  # engram's two shards, at the versions shard.lock records, each verified by sha256.
  resource "db" do
    url "https://github.com/crystal-lang/crystal-db/archive/refs/tags/v0.13.1.tar.gz"
    sha256 "3d410f0fae612d209904b01a0e6c7b24a00e686342447afcc43b869e6f1d1cf7"
  end

  resource "sqlite3" do
    url "https://github.com/crystal-lang/crystal-sqlite3/archive/refs/tags/v0.21.0.tar.gz"
    sha256 "c3d91ce0fad147c05dcfab98f84b94a93e0982d9f681ce4caa1da6cb9d54f8a0"
  end

  def install
    # Crystal programs trust $PWD for Dir.current; Homebrew can keep a caller's $PWD it may not read.
    ENV["PWD"] = buildpath.to_s
    ENV["CRYSTAL_CACHE_DIR"] = (buildpath/".crystal-cache").to_s
    (buildpath/"lib/db").install resource("db")
    (buildpath/"lib/sqlite3").install resource("sqlite3")

    compiler = formula_opt_bin("crimson-knight/agent-crystal/agent-crystal")/"crystal-alpha"
    system compiler, "build", "src/engram.cr", "-o", "engram", "--release"
    bin.install "engram"
  end

  test do
    ENV["PWD"] = testpath.to_s
    assert_match "engram #{version}", shell_output("#{bin}/engram version")

    # Scratch end-to-end: init creates .agents/memories + runs the first
    # sync, new scaffolds a migration file, sync picks it up.
    system "git", "init", "-q"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Homebrew Test"
    system bin/"engram", "init"
    system bin/"engram", "new", "test memory"
    assert_match "+1 applied", shell_output("#{bin}/engram sync")
  end
end
