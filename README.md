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
installs both `minecart` and `shards-alpha`.

If Minecart is already installed, run `brew uninstall shards-alpha` and stop here.
Otherwise run this block; each step runs only if the one before it passed. The old
keg is only unlinked (it stays installed and trusted) until Minecart is installed and
reports its exact version, and the whole Minecart formula file must be the reviewed
one (sha256 of `Formula/minecart.rb`) before Homebrew may load it.

```
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
! brew list --formula minecart >/dev/null 2>&1 &&
  brew update && brew tap amberframework/amber_cli &&
  MC="$(brew --repository amberframework/amber_cli)/Formula/minecart.rb" &&
  shasum -a 256 "$MC" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
  brew trust --formula amberframework/amber_cli/minecart &&
  brew fetch --build-from-source amberframework/amber_cli/minecart &&
  brew unlink shards-alpha &&
  brew install --build-from-source amberframework/amber_cli/minecart &&
  [ "$("$(brew --prefix minecart)/bin/minecart" --version | cut -d" " -f1-2)" = "Minecart 2025.11.25.8" ] &&
  brew uninstall shards-alpha
```

That formula file pins the Minecart 2025.11.25.8 release tarball, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`.

If a step fails, the previous build is still installed. In the same terminal,
remove any Minecart this attempt installed and relink it:

```
{ ! brew list --formula minecart >/dev/null 2>&1 || brew uninstall --ignore-dependencies minecart; } &&
  brew link shards-alpha &&
  shards-alpha --version
```
