# Neovim Configuration

This repository contains a curated Neovim configuration that sets up LSP, completion, linting, formatting, and developer UX plugins through Lazy.nvim.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration Reference (Manual)](#configuration-reference-manual)
  - [Entry Point](#entry-point)
  - [Plugin Management + Theme](#plugin-management--theme)
  - [Editor Options](#editor-options)
  - [Keymaps](#keymaps)
  - [Which-Key Menu](#which-key-menu)
  - [Autocommands](#autocommands)
  - [LSP](#lsp)
  - [Mason (LSP/Tool Installation)](#mason-lsptool-installation)
  - [Formatting](#formatting)
  - [Linting](#linting)
  - [Snippets](#snippets)
  - [Treesitter](#treesitter)
  - [Telescope](#telescope)
  - [Git Integrations](#git-integrations)
- [Common Updates](#common-updates)
  - [Change the Theme](#change-the-theme)
  - [Add or Update Snippets](#add-or-update-snippets)
  - [Add/Remove LSP Servers](#addremove-lsp-servers)
  - [Update Formatting or Linting Tools](#update-formatting-or-linting-tools)
  - [Adjust Keymaps](#adjust-keymaps)
  - [Adjust Treesitter Parsers](#adjust-treesitter-parsers)
- [Notes](#notes)
- [Repo Layout](#repo-layout)

## Features

- Lazy-managed plugin setup.
- Mason + mason-lspconfig for LSP server management.
- nvim-cmp with LuaSnip for completion and snippets.
- Treesitter syntax highlighting.
- Telescope, Harpoon, UndoTree, LazyGit, and more.

## Requirements

### Linux

- Neovim 0.9+ (recommended 0.10+).
- Git.
- Node.js + npm (for TypeScript/JavaScript tooling and some LSP servers).
- Optional: Python 3 (for some tooling), ripgrep (for Telescope search).

### macOS

- Neovim 0.9+ (recommended 0.10+).
- Git.
- Node.js + npm.
- Optional: Python 3, ripgrep.

## Installation

1. Back up any existing Neovim config:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repo into `~/.config/nvim`:

   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim:

   ```bash
   nvim
   ```

4. Lazy.nvim will bootstrap and install plugins on first launch.

## Configuration Reference (Manual)

Use this section as the "map" to every configurable area in the repo. Each bullet tells you exactly where to look for a specific kind of change.

### Entry Point

- `init.lua` is the main entry point that loads all configuration modules in order. Update module load order or add/remove modules here.

### Plugin Management + Theme

- `lua/plugins/init.lua` controls **all plugins** and plugin configuration.
- The current colorscheme is set by the LunarVim plugin block:
  - `LunarVim/lunar.nvim` + `vim.cmd.colorscheme("lunar")`.

### Editor Options

- `lua/config/options.lua` contains editor settings such as numbers, tabs, spellchecking, clipboard, and colors.

### Keymaps

- `lua/config/keymaps.lua` defines all custom key mappings, including:
  - Telescope find files
  - Diagnostics navigation
  - Comment toggling
  - Supermaven keybindings
  - Git blame toggle

### Which-Key Menu

- `lua/config/which_key.lua` defines the which-key labels and menu groupings for `<leader>` shortcuts.

### Autocommands

- `lua/config/autocmds.lua` contains all autocommands, including:
  - Spell highlight overrides
  - Filetype-specific spell settings
  - Format-on-save (LSP formatting)
  - GraphQL filetype detection

### LSP

- `lua/config/lsp.lua` defines **LSP server configuration** and LSP UI behavior.
  - Add server-specific settings here.
  - LSP diagnostic styling (floating borders, underline, etc.) lives here.

### Mason (LSP/Tool Installation)

- `lua/config/mason.lua` handles automatic installation for:
  - LSP servers (via `mason-lspconfig`)
  - CLI tools (via `mason-tool-installer`)

### Formatting

- `lua/config/formatting.lua` configures `conform.nvim`.
  - Filetype-to-formatter mapping is defined here.
  - `<leader>cf` runs manual format.

### Linting

- `lua/config/lint.lua` configures `nvim-lint`.
  - Filetype-to-linter mapping is defined here.
  - Linting runs on buffer enter, save, and leaving insert mode.

### Snippets

- `lua/config/snippets.lua` wires up LuaSnip and registers snippet sources.
- Actual snippet definitions live in:
  - `lua/snippets/typescript.lua`
  - `lua/snippets/typescriptreact.lua`
  - `lua/snippets/csharp.lua`

### Treesitter

- `lua/plugins/init.lua` configures Treesitter and its `ensure_installed` parsers list.

### Telescope

- `lua/plugins/init.lua` configures Telescope.
- Additional Telescope keybindings are in `lua/config/keymaps.lua` and which-key labels in `lua/config/which_key.lua`.

### Git Integrations

- `lua/plugins/init.lua` sets up git-related plugins (LazyGit, git-blame).
- `lua/config/keymaps.lua` has the toggle mapping for git blame and LazyGit.

## Common Updates

### Change the Theme

1. Open `lua/plugins/init.lua`.
2. Replace the `LunarVim/lunar.nvim` plugin with your preferred colorscheme plugin (or add a new one).
3. Update the colorscheme command to the new theme name:

   ```lua
   vim.cmd.colorscheme("your-theme-name")
   ```

### Add or Update Snippets

1. Add or update snippet definitions in `lua/snippets/*.lua`.
2. Register new filetypes in `lua/config/snippets.lua` if needed.
3. If you change the C# project root for namespaces, update it in `lua/config/snippets.lua`.

### Add/Remove LSP Servers

1. Add/remove servers in `lua/config/mason.lua` under `ensure_installed`.
2. Configure per-server settings in `lua/config/lsp.lua` inside the `servers` table.

### Update Formatting or Linting Tools

- Formatting tools: update `lua/config/formatting.lua` (formatters_by_ft).
- Linting tools: update `lua/config/lint.lua` (linters_by_ft).
- If the tool is managed by Mason, also update `lua/config/mason.lua`.

### Adjust Keymaps

- Update `lua/config/keymaps.lua` to add, remove, or modify key bindings.
- Update `lua/config/which_key.lua` to keep which-key labels in sync.

### Adjust Treesitter Parsers

- Update the `ensure_installed` list in `lua/plugins/init.lua`.

## Notes

- `:checkhealth` can help diagnose missing dependencies.
- `:checkhealth which-key` can highlight conflicting keymaps.
- `:ProjectNotes` (or `<leader>on`) opens a per-project notes file stored under `stdpath("data")/project-notes` in a floating window.
- `:ProjectTerminalToggle` (or `<leader>ot`) toggles a floating terminal panel for running shell commands.
- `:ProjectTerminalOpen` and `:ProjectTerminalClose` explicitly open/close the same terminal panel; close hides the window and keeps the job running.
- `:ProjectTerminalKill` stops the running terminal job.

## Repo Layout

- `init.lua` — main entry point.
- `lua/plugins/init.lua` — plugin declarations and configuration.
- `lua/config/` — LSP, Mason, options, keymaps, and other config modules.
- `lua/snippets/` — LuaSnip snippet definitions by filetype.
