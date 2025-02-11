local M = {}

function M.osname()
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
  local input_file = vim.fn.getcwd() .. "/output/input.txt"
  local file = io.open(input_file, "r")

  if file then
    file:close()
    return input_file
  else
    return nil
  end
end

return M
