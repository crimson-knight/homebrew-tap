# Homebrew Tap

Custom Homebrew formulae for Crystal development tools.

## Install

```
brew tap crimson-knight/tap
```

## Available Formulae

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
