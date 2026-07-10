class Engram < Formula
  desc "Branch-scoped memory for coding agents — perfect recall on checkout, clean amnesia on switch"
  homepage "https://github.com/crimson-knight/engram"
  url "https://github.com/crimson-knight/engram/archive/refs/tags/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "e201995360597c02b3de910aa474d25ab57118585ea9333f3543cca721581e3d"
  license "MIT"

  depends_on "crystal" => :build
  depends_on "openssl@3"

  # engram's only shard dependencies are crystal-lang/crystal-db and
  # crystal-lang/crystal-sqlite3 — ordinary shards.crystal-lang.org packages
  # with no exotic build requirements, so the stock `shards` bundled with
  # Homebrew's `crystal` formula builds them fine; no shards-alpha fork needed.
  # openssl@3 is needed explicitly (not just transitively via crystal) because
  # Homebrew's build sandbox only wires up pkg-config/library paths for a
  # formula's own declared dependencies: engram's stdlib Digest::SHA256 links
  # against libssl/libcrypto, and macOS ships neither, so without this the
  # linker falls back to a bare `-lssl -lcrypto` with no `-L` path and fails.
  def install
    system "shards", "install", "--without-development"
    system "crystal", "build", "src/engram.cr", "-o", "engram", "--release"
    bin.install "engram"
  end

  test do
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
