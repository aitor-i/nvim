local lspconfig = require("lspconfig")

lspconfig.intelephense.setup({
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
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})
