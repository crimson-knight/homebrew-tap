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

Paste this whole block into one bash terminal; it works whether or not this tap's
`shards-alpha` or Minecart is installed. It records what is installed, linked and
trusted before it changes anything, so `rollback_minecart` undoes only what this
attempt did. Each step runs only if the one before it passed. The old keg is only
unlinked until Minecart is installed, linked, and both linked commands report the
exact version; the whole Minecart formula file must be the reviewed one before
Homebrew may load it; and auto-update, autoremove and install cleanup are off.

```bash
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTOREMOVE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
installed() { brew list --formula "$1" >/dev/null 2>&1; }
linked() { brew info --json=v2 "$1" 2>/dev/null | grep -q '"linked_keg": *"[^"]'; }
trusted() { brew trust --json v1 | grep -q "\"$1\""; }
check_minecart() {
  bin="$(brew --prefix)/bin" &&
    case "$(readlink "$bin/minecart")" in ../Cellar/minecart/2025.11.25.8/bin/minecart) ;; *) false ;; esac &&
    case "$(readlink "$bin/shards-alpha")" in ../Cellar/minecart/2025.11.25.8/bin/shards-alpha) ;; *) false ;; esac &&
    out=$("$bin/minecart" --version) && [ "$out" = "Minecart 2025.11.25.8 (2026-10-06)" ] &&
    out=$("$bin/shards-alpha" --version 2>/dev/null) && [ "$out" = "Minecart 2025.11.25.8 (2026-10-06)" ]
}
had_mc=$(installed minecart && echo y); had_sa=$(installed shards-alpha && echo y)
had_link_sa=$(linked shards-alpha && echo y)
had_trust_mc=$(trusted amberframework/amber_cli/minecart && echo y)
rollback_minecart() {
  { [ -n "$had_mc" ] || ! installed minecart || brew uninstall --ignore-dependencies minecart; } &&
    { [ -n "$had_trust_mc" ] || brew untrust --formula amberframework/amber_cli/minecart; } &&
    { [ -z "$had_link_sa" ] || brew link shards-alpha; }
}
if [ -n "$had_mc" ]; then
  # Minecart is already installed: unlink the old keg, link Minecart, check, then remove.
  { [ -z "$had_link_sa" ] || brew unlink shards-alpha; } &&
    brew link minecart && check_minecart &&
    { [ -z "$had_sa" ] || brew uninstall shards-alpha; } ||
    { echo "Migration stopped; run: rollback_minecart"; false; }
else
  brew update && brew tap amberframework/amber_cli &&
    digest=$(shasum -a 256 "$(brew --repository amberframework/amber_cli)/Formula/minecart.rb") &&
    [ "${digest%% *}" = "ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37" ] &&
    brew trust --formula amberframework/amber_cli/minecart &&
    brew fetch --build-from-source amberframework/amber_cli/minecart &&
    { [ -z "$had_link_sa" ] || brew unlink shards-alpha; } &&
    brew install --build-from-source amberframework/amber_cli/minecart &&
    check_minecart &&
    { [ -z "$had_sa" ] || brew uninstall shards-alpha; } ||
    { echo "Migration stopped; run: rollback_minecart"; false; }
fi
```

That formula file pins the Minecart 2025.11.25.8 release tarball, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`. If the block
stops, run `rollback_minecart` in the same terminal. Minecart stays trusted after a
successful migration, because Homebrew must load it to upgrade.
