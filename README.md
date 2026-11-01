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

Minecart 2025.11.25.8 builds from its release tarball, sha256
`15c7c0af5f29dbd5d651fbfe90bfe1c0cd614a5e72a55ccacc2c246c6e1ed38f`, through the
`minecart` formula in the Amber CLI tap at commit
`add328ed517dfffc6b0b07293b85fe25ae140bdc` (formula file sha256
`ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37`).

To move from this tap's `shards-alpha`:

1. `brew unlink crimson-knight/tap/shards-alpha`, so Minecart can link its own
   `shards-alpha`. Keep the old keg installed for now.
2. Tap, pin and verify the reviewed formula, then install it. Paste the block as
   one command: each step runs only if the one before it succeeded, so a hash
   mismatch stops it before `brew install`.
   ```sh
   T="$(brew tap amberframework/amber_cli >/dev/null && brew --repo amberframework/amber_cli)" &&
   git -C "$T" checkout --detach add328ed517dfffc6b0b07293b85fe25ae140bdc &&
   printf "%s  %s\n" ee4a9a4ce105ef2bbd8a0b7a3503285dee5b0033dd3a46a729dbaa66b3ab9c37 "$T/Formula/minecart.rb" | shasum -a 256 -c - &&
   HOMEBREW_NO_AUTO_UPDATE=1 brew install amberframework/amber_cli/minecart
   ```
3. Check it: `minecart --version` and `shards-alpha --version` both print
   `Minecart 2025.11.25.8 (2026-10-06)`.
4. Only then remove the old keg: `brew uninstall crimson-knight/tap/shards-alpha`.

If step 2 or 3 fails, put the previous build back while you sort it out:
`brew unlink amberframework/amber_cli/minecart` (when it is linked), then
`brew link crimson-knight/tap/shards-alpha`. Run
`git -C "$(brew --repo amberframework/amber_cli)" checkout main` to return the
Amber CLI tap to its normal branch afterward.
