local M = {}

function M.os_name()
  local osname

  -- ask LuaJIT first
  if jit then
    return jit.os
  end

  -- unix, linux variants
  local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
  if fh then
    osname = fh:read()
  end

  return osname or "Windows"
end

function M.check_input_file()
  local input_file = vim.fn.expand("%:p:h") .. "/output/input.txt"

  if vim.fn.filereadable(input_file) == 1 then
    return input_file
  else
    return nil
  end
end

function M.close_wins_and_bufs()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Step 1: Loop through all windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if win ~= current_win then
      -- Step 2: Close the window
      vim.api.nvim_win_close(win, true)

      -- Step 3: Delete the buffer if it's not used elsewhere
      if buf ~= current_buf and vim.fn.buflisted(buf) == 1 then
        vim.cmd("bdelete " .. buf)
      end
    end
  end
end

function M.is_file_open_in_window(filepath)
  local target = vim.fn.fnamemodify(filepath, ":p") -- normalize full path

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.fn.fnamemodify(name, ":p") == target then
      return true, win -- file is open in this window
    end
  end

  return false, nil -- file not open in any window
end

function M.find_cpp_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("%.cpp$") then
      return bufnr
    end
  end
  error("No .cpp buffer found")
end

return M
