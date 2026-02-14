local M = {}

local state = {
  buf = nil,
  win = nil,
  chan = nil,
}

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_job_running(chan)
  if not chan then
    return false
  end

  local ok, info = pcall(vim.api.nvim_get_chan_info, chan)
  if not ok or not info then
    return false
  end

  return info.stream == "job"
end

local function calculate_window_layout()
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.35)
  local row = vim.o.lines - height - 2
  local col = math.floor((vim.o.columns - width) / 2)

  return {
    relative = "editor",
    row = math.max(row, 1),
    col = math.max(col, 0),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  }
end

local function start_terminal_job()
  if not is_valid_buf(state.buf) then
    return
  end

  vim.api.nvim_buf_call(state.buf, function()
    state.chan = vim.fn.termopen(vim.o.shell)
  end)
end

local function ensure_terminal()
  if not is_valid_buf(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(state.buf, "Project Terminal")
    vim.bo[state.buf].bufhidden = "hide"
  end

  if not is_job_running(state.chan) then
    start_terminal_job()
  end
end

function M.open()
  if is_valid_win(state.win) then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("startinsert")
    return
  end

  ensure_terminal()

  state.win = vim.api.nvim_open_win(state.buf, true, calculate_window_layout())

  vim.api.nvim_set_option_value("number", false, { win = state.win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = state.win })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = state.win })

  vim.cmd("startinsert")
end

function M.close()
  if not is_valid_win(state.win) then
    return
  end

  vim.api.nvim_win_close(state.win, true)
  state.win = nil
end

function M.kill()
  if is_job_running(state.chan) then
    vim.fn.jobstop(state.chan)
  end

  state.chan = nil

  if is_valid_win(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.toggle()
  if is_valid_win(state.win) then
    M.close()
  else
    M.open()
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    if state.win and tostring(state.win) == args.match then
      state.win = nil
    end
  end,
})

vim.api.nvim_create_user_command("ProjectTerminalOpen", M.open, {
  desc = "Open project terminal window",
})

vim.api.nvim_create_user_command("ProjectTerminalClose", M.close, {
  desc = "Close project terminal window and keep the running job",
})

vim.api.nvim_create_user_command("ProjectTerminalKill", M.kill, {
  desc = "Stop project terminal job",
})

vim.api.nvim_create_user_command("ProjectTerminalToggle", M.toggle, {
  desc = "Toggle project terminal window",
})

return M
