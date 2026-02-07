local function get_project_root()
  local ok, result = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
  if ok and result and result[1] and result[1] ~= "" then
    return result[1]
  end

  return vim.fn.getcwd()
end

local function open_project_notes()
  local root = get_project_root()
  local notes_path = root .. "/.project-notes.md"

  if vim.fn.filereadable(notes_path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(notes_path, ":h"), "p")
    vim.fn.writefile({ "# Project Notes", "", "" }, notes_path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(notes_path))
end

vim.api.nvim_create_user_command("ProjectNotes", open_project_notes, {
  desc = "Open project notes for the current project",
})
