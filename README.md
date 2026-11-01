# Homebrew Tap

Custom Homebrew formulae for Crystal development tools.

## Install

```
brew tap crimson-knight/tap
```

## Available Formulae

### engram

Branch-scoped memory for coding agents: decisions live as migration files in
the repo and follow your branches. Includes an MCP server, and an agent kit
for Claude Code and Codex CLI.

```
brew install crimson-knight/tap/engram
engram version    # engram 0.2.0
```

The formula is pinned to the v0.2.0 release tarball (sha256 checked by
Homebrew) and installs its shards strictly from `shard.lock`. See the
[engram README](https://github.com/crimson-knight/engram#install) for the
agent kit install.

### shards-alpha (deprecated)

`shards-alpha` from this tap is deprecated in favor of Minecart, which is the
same project (crimson-knight/shards) at a newer, sha256-pinned release and
installs both `minecart` and `shards-alpha`:

```
brew update
brew tap amberframework/amber_cli
# Each step runs only if the one before it passed. The whole formula file must be the
# reviewed one (sha256 of Formula/minecart.rb) before Homebrew is allowed to load it.
MC="$(brew --repository amberframework/amber_cli)/Formula/minecart.rb" &&
  shasum -a 256 "$MC" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
  brew trust --formula amberframework/amber_cli/minecart &&
  HOMEBREW_NO_AUTO_UPDATE=1 brew fetch --build-from-source amberframework/amber_cli/minecart &&
  HOMEBREW_NO_AUTOREMOVE=1 brew uninstall shards-alpha &&
  HOMEBREW_NO_AUTO_UPDATE=1 brew install --build-from-source amberframework/amber_cli/minecart &&
  minecart --version && shards-alpha --version
```

That formula file pins the Minecart 2025.11.25.8 release tarball, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`.

If the Minecart install fails after `shards-alpha` was removed, put the previous
build back:

```
{ ! brew list --formula minecart >/dev/null 2>&1 ||
    HOMEBREW_NO_AUTOREMOVE=1 brew uninstall --ignore-dependencies minecart; } &&
  HOMEBREW_NO_AUTO_UPDATE=1 brew install crimson-knight/tap/shards-alpha &&
  brew list --versions shards-alpha &&
  shards-alpha --version
```
