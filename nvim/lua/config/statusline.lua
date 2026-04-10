local function diagnostics_segment()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  return string.format("%%#DiagnosticError#E%%*:%d %%#DiagnosticWarn#W%%*:%d %%#DiagnosticHint#H%%*:%d", errors, warnings, hints)
end

function _G.statusline_diagnostics()
  return diagnostics_segment()
end

vim.opt.statusline = table.concat({
  " %<%F",
  " %=",
  " %{v:lua.statusline_diagnostics()}",
  "  Ln %l, Col %c",
  "  %p%% ",
})
