local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 1000,
  },
})

vim.keymap.set("n", "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })
