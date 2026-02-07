-- ~/.config/nvim/init.lua

-- leader key (must be first)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("plugins")

require("config.snippets")
require("config.lsp")
require("config.which_key")
