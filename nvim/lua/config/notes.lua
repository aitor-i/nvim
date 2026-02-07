local function get_project_root()
  local ok, result = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
  if ok and result and result[1] and result[1] ~= "" then
    return result[1]
  end

  return vim.fn.getcwd()
end

local function get_notes_path(project_root)
  local notes_dir = vim.fn.stdpath("data") .. "/project-notes"
  local project_name = vim.fn.fnamemodify(project_root, ":t")
  local project_hash = vim.fn.sha256(project_root):sub(1, 8)

  vim.fn.mkdir(notes_dir, "p")

  return string.format("%s/%s-%s.md", notes_dir, project_name, project_hash)
end

local function open_floating_notes(notes_path)
  local buf = vim.fn.bufadd(notes_path)
  vim.fn.bufload(buf)

  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_set_option_value("wrap", true, { win = win })
end

local function open_project_notes()
  local root = get_project_root()
  local notes_path = get_notes_path(root)

  if vim.fn.filereadable(notes_path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(notes_path, ":h"), "p")
    vim.fn.writefile({ "# Project Notes", "", "" }, notes_path)
  end

  open_floating_notes(notes_path)
end

vim.api.nvim_create_user_command("ProjectNotes", open_project_notes, {
  desc = "Open project notes for the current project",
})
