local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({})

mason_lspconfig.setup({
  ensure_installed = {
    "cssls",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "tailwindcss",
    "ts_ls",
  },
})

mason_tool_installer.setup({
  ensure_installed = {
    "eslint_d",
    "prettier",
    "typescript-language-server",
  },
})
