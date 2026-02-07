local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities()
local border = "rounded"

vim.diagnostic.config({
  float = { border = border, source = "always" },
  severity_sort = true,
  update_in_insert = false,
  underline = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

lspconfig.intelephense.setup({
  capabilities = capabilities,
  settings = {
    intelephense = {
      stubs = { "wordpress", "php", "core", "curl", "json", "mysqli", "pdo", "xml" },
      environment = {
        includePaths = {
          vim.fn.expand("~/Developer/learn/wordpress/wp-first/.stubs/wordpress"),
        },
      },
    },
  },
})

lspconfig.omnisharp.setup({
  handlers = {
    ["textDocument/definition"] = function(...)
      return vim.lsp.handlers["textDocument/definition"](...)
    end,
  },
  capabilities = capabilities,
})

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

lspconfig.eslint.setup({
  capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  capabilities = capabilities,
})

lspconfig.html.setup({
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
