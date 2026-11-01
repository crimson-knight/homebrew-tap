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

These steps are for a machine that has this tap's `shards-alpha` installed. On a
fresh machine, install Minecart with the pinned steps in the
[Amber CLI tap README](https://github.com/amberframework/homebrew-amber_cli#install).

Each step below runs only if the one before it passed. `check_minecart` requires
the exact version line from Minecart and from its `shards-alpha` alias, run from
Minecart's own prefix.

```
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
check_minecart() {
  p=$(brew --prefix minecart) &&
    out=$("$p/bin/minecart" --version) && [ "$out" = "Minecart 2025.11.25.8 (2026-10-06)" ] &&
    out=$("$p/bin/shards-alpha" --version 2>/dev/null) && [ "$out" = "Minecart 2025.11.25.8 (2026-10-06)" ]
}
```

If Minecart is already installed, check it and then remove the old keg:

```
check_minecart && brew uninstall shards-alpha
```

Otherwise install it. The old keg is only unlinked (it stays installed and trusted)
until Minecart passes `check_minecart`, and the whole Minecart formula file must be
the reviewed one (sha256 of `Formula/minecart.rb`) before Homebrew may load it:

```
brew list --formula shards-alpha >/dev/null 2>&1 &&
  ! brew list --formula minecart >/dev/null 2>&1 &&
  brew update && brew tap amberframework/amber_cli &&
  MC="$(brew --repository amberframework/amber_cli)/Formula/minecart.rb" &&
  shasum -a 256 "$MC" | grep -q "^ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 " &&
  brew trust --formula amberframework/amber_cli/minecart &&
  brew fetch --build-from-source amberframework/amber_cli/minecart &&
  brew unlink shards-alpha &&
  brew install --build-from-source amberframework/amber_cli/minecart &&
  check_minecart &&
  brew uninstall shards-alpha
```

That formula file pins the Minecart 2025.11.25.8 release tarball, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`.

If a step fails, the previous build is still installed. In the same terminal,
remove any Minecart this attempt installed, withdraw its trust, and relink:

```
{ ! brew list --formula minecart >/dev/null 2>&1 || brew uninstall --ignore-dependencies minecart; } &&
  brew untrust --formula amberframework/amber_cli/minecart &&
  brew link shards-alpha &&
  shards-alpha --version
```
