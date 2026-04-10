-- ~/.config/nvim/init.lua

-- leader key (must be first)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.statusline")
require("config.notes")
require("config.terminal")
require("config.checkpoints")
require("config.keymaps")
require("config.autocmds")

require("plugins")

require("config.colorscheme")
require("config.snippets")
require("config.mason")
require("config.lsp")
require("config.formatting")
require("config.lint")
require("config.which_key")
