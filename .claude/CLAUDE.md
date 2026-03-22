# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Vim configuration repository (vimfiles). Cloned into `~/.vim` (Linux) or `%USERPROFILE%/vimfiles` (Windows) to serve as the Vim runtime directory.

## Architecture

- **Plugin manager**: Pathogen. Loaded via `autoload/pathogen.vim` (copied from the `vim-pathogen` submodule). Plugins live in `bundle/` and are auto-loaded by `pathogen#infect()`.
- **All plugins are git submodules** under `bundle/`. There are 23 of them.
- **Main config**: `vimrc` -- the single configuration file. It loads vim-sensible early (`runtime! plugin/sensible.vim`) then overrides settings.
- **After scripts**: `after/plugin/` runs after plugins load (e.g., abolish.vim defines spelling corrections that require the abolish plugin).
- **Local overrides**: `vimrc` sources `vimrc_local` and `vimrc_local_gui` if they exist (not tracked in git).

## Common Commands

### Adding a plugin

```
git submodule add <url> bundle/<name>
```

### Updating all plugins to latest

```
git submodule foreach "(git checkout master && git pull)&"
git add bundle/
git commit
```

### Updating the repo (after pull)

```
git submodule init
git submodule update
```

## Conventions

- The vimrc uses `has('eval')`, `has('autocmd')`, etc. guards for compatibility with minimal Vim builds. Maintain this pattern when adding new config.
- Indentation in vimrc: 2 spaces (see modeline at end of file).
- Plugin configuration goes in the "Plugin configuration" section of vimrc. Autocmds go inside the `augroup vimrc` block.
- Custom commands (like `:Cleanup`) are defined with `<SID>` scoped functions.
