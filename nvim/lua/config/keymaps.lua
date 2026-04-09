function _G.lsp_hover_with_feedback()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP client attached to this buffer", vim.log.levels.WARN)
    return
  end

  local supports_hover = false
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/hover") then
      supports_hover = true
      break
    end
  end

  if not supports_hover then
    vim.notify("Attached LSP clients do not support hover", vim.log.levels.WARN)
    return
  end

  local params = vim.lsp.util.make_position_params(0, "utf-16")
  vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result, ctx, config)
    if err then
      vim.notify("Hover request failed: " .. (err.message or "unknown error"), vim.log.levels.WARN)
      return
    end

    if not (result and result.contents) then
      vim.notify("No hover documentation available at this position", vim.log.levels.INFO)
      return
    end

    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)

    if vim.tbl_isempty(markdown_lines) then
      vim.notify("No hover documentation available at this position", vim.log.levels.INFO)
      return
    end

    local hover_config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
    vim.lsp.util.open_floating_preview(markdown_lines, "markdown", hover_config)
  end)
end

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>lua require('telescope.builtin').git_files({ show_untracked = true })<CR>")
vim.keymap.set("n", "<leader>x", "/")
vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "K", _G.lsp_hover_with_feedback, { desc = "LSP Hover" })
vim.keymap.set("n", "<leader>ch", _G.lsp_hover_with_feedback, { desc = "LSP Hover Documentation" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.type_definition, { desc = "LSP Type Definition" })
vim.keymap.set("n", "<leader>sn", "]s")
vim.keymap.set("n", "<leader>sp", "[s")
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")
vim.keymap.set("n", "J", "}")
vim.keymap.set("n", "<C-j>", "}")
vim.keymap.set("n", "<C-k>", "{")
vim.keymap.set("n", "r", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "R", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>")
vim.keymap.set("n", "<leader>on", "<cmd>ProjectNotes<CR>")
vim.keymap.set("n", "<leader>ot", "<cmd>ProjectTerminalToggle<CR>")
vim.keymap.set("n", "<leader>ct", function() require("config.checkpoints").toggle() end)
vim.keymap.set("n", "<leader>cn", function() require("config.checkpoints").next() end)
vim.keymap.set("n", "<leader>cC", function() require("config.checkpoints").clear() end)

function _G.find_all_files()
  require("telescope.builtin").find_files({
    prompt_title = "All files (incl. .gitignored)",
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end

function _G.supermaven_accept_suggestion()
  local suggestion = require("supermaven-nvim.completion_preview")
  if suggestion and suggestion.has_suggestion and suggestion.has_suggestion() then
    vim.schedule(function()
      suggestion.on_accept_suggestion()
    end)
    return ""
  end
  return "<C-b>"
end

vim.keymap.set("i", "<C-b>", "v:lua.supermaven_accept_suggestion()", { expr = true, noremap = true })
vim.keymap.set("i", "<C-l>", 'supermaven#Accept("<C-l>")', { expr = true, noremap = true })
vim.keymap.set("i", "<C-h>", "supermaven#Dismiss()", { expr = true, noremap = true })

local function escape_lua_pattern(text)
  return (text:gsub("([^%w])", "%%%1"))
end

local function get_comment_parts()
  local commentstring = vim.bo.commentstring
  if not commentstring or commentstring == "" or not commentstring:find("%%s") then
    return nil, nil
  end

  local prefix, suffix = commentstring:match("^(.*)%%s(.*)$")
  return vim.trim(prefix or ""), vim.trim(suffix or "")
end

local function is_line_commented(line, prefix, suffix)
  if line:match("^%s*$") then
    return true
  end

  local prefix_pattern = "^%s*" .. escape_lua_pattern(prefix) .. "%s?"
  if suffix ~= "" then
    local suffix_pattern = "%s*" .. escape_lua_pattern(suffix) .. "%s*$"
    return line:match(prefix_pattern .. ".-" .. suffix_pattern) ~= nil
  end
  return line:match(prefix_pattern) ~= nil
end

local function uncomment_line(line, prefix, suffix)
  local indent, body = line:match("^(%s*)(.*)$")
  if not indent or not body then
    return line
  end

  if suffix ~= "" then
    local pattern = "^" .. escape_lua_pattern(prefix) .. "%s?(.-)%s*" .. escape_lua_pattern(suffix) .. "%s*$"
    local stripped = body:match(pattern)
    if stripped ~= nil then
      return indent .. stripped
    end
    return line
  end

  local pattern = "^" .. escape_lua_pattern(prefix) .. "%s?(.*)$"
  local stripped = body:match(pattern)
  if stripped ~= nil then
    return indent .. stripped
  end

  return line
end

local function comment_line(line, prefix, suffix)
  local indent, body = line:match("^(%s*)(.*)$")
  if not indent or not body then
    return line
  end

  if suffix ~= "" then
    if body == "" then
      return indent .. prefix .. " " .. suffix
    end
    return indent .. prefix .. " " .. body .. " " .. suffix
  end

  if body == "" then
    return indent .. prefix
  end

  return indent .. prefix .. " " .. body
end

vim.api.nvim_create_user_command("CommentToggle", function(opts)
  local prefix, suffix = get_comment_parts()
  if not prefix or prefix == "" then
    vim.notify("commentstring is not configured for this buffer", vim.log.levels.WARN)
    return
  end

  local start_line = opts.line1 - 1
  local end_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  if #lines == 0 then
    return
  end

  local all_commented = true
  for _, line in ipairs(lines) do
    if not is_line_commented(line, prefix, suffix) then
      all_commented = false
      break
    end
  end

  local updated_lines = {}
  for _, line in ipairs(lines) do
    if all_commented then
      table.insert(updated_lines, uncomment_line(line, prefix, suffix))
    else
      table.insert(updated_lines, comment_line(line, prefix, suffix))
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, updated_lines)
end, { range = true })

vim.keymap.set("n", "<leader>k", "<cmd>CommentToggle<CR>")
vim.keymap.set("v", "<leader>k", ":<C-U>CommentToggle<CR>")

vim.g.gitblame_message_template = "<author> • <date> • <summary>"
