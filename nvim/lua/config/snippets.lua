local ls = require("luasnip")

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

function _G.calculate_csharp_namespace()
  local file_dir = vim.fn.expand("%:p:h")
  local cwd = vim.loop.cwd() or ""

  local relative = vim.fn.fnamemodify(file_dir, ":.")
  if relative == file_dir and cwd ~= "" and file_dir:find(cwd, 1, true) == 1 then
    relative = file_dir:sub(#cwd + 2)
  end

  if relative == "." or relative == "" then
    return "App"
  end

  return relative:gsub("[/\\]", ".")
end

ls.add_snippets("csharp", require("snippets.csharp"), { key = "custom-csharp" })
ls.add_snippets("typescript", require("snippets.typescript"), { key = "custom-typescript" })
ls.add_snippets("typescriptreact", require("snippets.typescriptreact"), { key = "custom-typescriptreact" })

ls.filetype_extend("typescriptreact", { "typescript" })
