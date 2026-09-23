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

### shards-alpha

Fork of Crystal's [Shards](https://github.com/crystal-lang/shards) package manager with alpha features: AI docs distribution, SBOM generation, MCP server distribution, docs theming, and postinstall script tracking.

```
brew install shards-alpha
```

Installs as `shards-alpha` alongside the stock `shards` command -- no conflicts.

```
shards-alpha install              # Install dependencies (with AI docs)
shards-alpha sbom                 # Generate SPDX 2.3 SBOM
shards-alpha sbom --format=cyclonedx  # Generate CycloneDX 1.6 SBOM
shards-alpha ai-docs              # Manage AI documentation from deps
shards-alpha docs                 # Generate themed docs with AI buttons
```
