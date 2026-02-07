local wk = require("which-key")

wk.register({
  a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add to Harpoon" },
  e = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Harpoon Menu" },
  h = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "Harpoon File 1" },
  t = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "Harpoon File 2" },
  n = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "Harpoon File 3" },
  m = { "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", "Harpoon File 4" },
  u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  x = { "/", "Search in Document" },
  s = {
    name = "+Spell",
    n = { "]s", "Next Spell Error" },
    p = { "[s", "Previous Spell Error" },
    c = { ":nohlsearch<CR>", "Clear Highlight" },
    s = { "z=", "Suggest Spelling" },
  },
  P = {
    "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ') })<CR>",
    "Grep Finding",
  },
  f = { "<cmd>lua require('telescope.builtin').git_files({ show_untracked = true })<CR>", "Find Git Files" },
  F = { "<cmd>lua find_all_files()<CR>", "Find All Files" },
  c = { f = { "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<CR>", "Format File" } },
  g = { g = { "<cmd>LazyGit<CR>" } },
  gb = { "<cmd>GitBlameToggle<CR>", "Toggle Git Blame" },
  z = { "<C-w>w", "Next Window" },
  k = { "<cmd>CommentToggle<CR>", "Toggle Comment" },
}, { prefix = "<leader>" })
