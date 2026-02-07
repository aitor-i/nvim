local M = {}

local sign_name = "CheckpointSign"
local sign_group = "CheckpointSigns"
local hl_group = "CheckpointSign"

vim.api.nvim_set_hl(0, hl_group, { link = "DiagnosticInfo", default = true })
vim.fn.sign_define(sign_name, { text = "●", texthl = hl_group, numhl = "" })

local buffer_state = {}

local function get_state(bufnr)
  local state = buffer_state[bufnr]
  if not state then
    state = { lines = {}, next_id = 1 }
    buffer_state[bufnr] = state
  end
  return state
end

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local state = get_state(bufnr)
  local existing = state.lines[line]

  if existing then
    vim.fn.sign_unplace(sign_group, { buffer = bufnr, id = existing })
    state.lines[line] = nil
    return
  end

  local id = state.next_id
  state.next_id = id + 1
  vim.fn.sign_place(id, sign_group, sign_name, bufnr, { lnum = line, priority = 10 })
  state.lines[line] = id
end

function M.next()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = get_state(bufnr)
  local lines = {}
  for line, _ in pairs(state.lines) do
    table.insert(lines, line)
  end

  if #lines == 0 then
    vim.notify("No checkpoints set in this buffer.", vim.log.levels.INFO)
    return
  end

  table.sort(lines)
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local target = lines[1]
  for _, line in ipairs(lines) do
    if line > current then
      target = line
      break
    end
  end

  vim.api.nvim_win_set_cursor(0, { target, 0 })
end

function M.clear()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace(sign_group, { buffer = bufnr })
  buffer_state[bufnr] = { lines = {}, next_id = 1 }
end

return M
