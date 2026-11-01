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
# Check the formula before removing the working shards-alpha:
# expect version 2025.11.25.8 and sha256 15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f
brew cat amberframework/amber_cli/minecart | grep -E "^  (version|sha256) "
brew trust --formula amberframework/amber_cli/minecart   # Homebrew 7 asks for this
brew uninstall shards-alpha
HOMEBREW_NO_AUTO_UPDATE=1 brew install amberframework/amber_cli/minecart
minecart --version && shards-alpha --version
```

If the Minecart install fails, `brew install crimson-knight/tap/shards-alpha`
puts the previous build back.
