vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>lua require('telescope.builtin').git_files({ show_untracked = true })<CR>")
vim.keymap.set("n", "<leader>x", "/")
vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
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

vim.api.nvim_create_user_command("CommentToggle", function()
  local cs = vim.bo.commentstring:gsub("%%s", ""):gsub(" ", "")

  if vim.fn.mode() == "n" then
    local line = vim.api.nvim_get_current_line()
    if vim.startswith(line, cs) then
      vim.api.nvim_set_current_line(line:sub(#cs + 1))
    else
      vim.api.nvim_set_current_line(cs .. line)
    end
  elseif vim.fn.mode() == "V" or vim.fn.mode() == "v" or vim.fn.mode() == "" then
    vim.cmd("normal! `<v`>y")
    local lines = vim.fn.split(vim.fn.getreg('"'), "\n")

    local all_commented = true
    for _, line in ipairs(lines) do
      if not vim.startswith(line, cs) then
        all_commented = false
        break
      end
    end

    local new_lines = {}
    for _, line in ipairs(lines) do
      if all_commented then
        table.insert(new_lines, line:sub(#cs + 1))
      else
        table.insert(new_lines, cs .. line)
      end
    end

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2] - 1
    local end_line = end_pos[2] - (all_commented and 1 or 0)

    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, new_lines)
    vim.cmd(start_line + 1 .. "," .. end_line .. "normal! gv")
  end
end, {})

vim.keymap.set("n", "<leader>k", "<cmd>CommentToggle<CR>")
vim.keymap.set("v", "<leader>k", ":<C-U>CommentToggle<CR>")

vim.g.gitblame_message_template = "<author> • <date> • <summary>"
