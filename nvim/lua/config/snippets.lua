local ls = require("luasnip")

function _G.calculate_csharp_namespace()
  local path = vim.fn.expand("%:p:h")
  local project_root = "path/to/your/project"
  local path_relative = path:sub(#project_root + 2)
  local namespace = path_relative:gsub("[/\\]", ".")
  return namespace
end

ls.snippets = {
  csharp = require("snippets.csharp"),
  typescript = require("snippets.typescript"),
  typescriptreact = require("snippets.typescriptreact"),
}
