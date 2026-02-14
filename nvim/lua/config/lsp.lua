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

local function apply_first_quickfix_action()
  local params = vim.lsp.util.make_range_params(0)
  params.context = { only = { "quickfix", "source.addMissingImports.ts", "source.organizeImports" } }

  vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.lsp.buf.code_action()
      return
    end

    local action = result[1]
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
    end
    if action.command then
      vim.lsp.buf.execute_command(action.command)
    end
  end)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("n", "<C-Space>", apply_first_quickfix_action, opts)
  end,
})

local servers = {
  intelephense = {
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
  },
  omnisharp = {
    handlers = {
      ["textDocument/definition"] = function(...)
        return vim.lsp.handlers["textDocument/definition"](...)
      end,
    },
  },
  ts_ls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  eslint = {},
  tailwindcss = {},
  cssls = {},
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },
}

for server, config in pairs(servers) do
  local merged = vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {})
  vim.lsp.config(server, merged)
  vim.lsp.enable(server)
end
