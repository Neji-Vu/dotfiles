local M = {}

local myfunc = require("manhcuong.myfunc")

function M.BuildCppFile()
  -- A command to build cpp file
  local gcc = "g++ -o output/%:r % -std=c++11"

  -- A command to make the output folder holding the executable files
  local flag = myfunc.os_name() == "Windows" and "-f" or "-p"
  local suppress = myfunc.os_name() == "Windows" and "$null" or "/dev/null"
  local dir = string.format("mkdir %s output > %s", flag, suppress)

  -- the final command to build cpp in the new buffer
  local command = string.format(":w<cr>:split<cr>:te %s && %s <cr>", dir, gcc)
  vim.keymap.set("n", "<leader>cb", command, { desc = "Build cpp file", noremap = true, silent = true })
end

function M.RunCppFile()
  local command = ":split<CR>:te ./output/%:r<CR>i"
  vim.keymap.set("n", "<leader>ce", command, { desc = "Run cpp file", noremap = true, silent = true })

  local command_file = ":split<CR>:te ./output/%:r < output/input.txt<CR>i"
  vim.keymap.set(
    "n",
    "<leader>cE",
    command_file,
    { desc = "Run cpp file with input file", noremap = true, silent = true }
  )
end

function M.GenerateCppFile()
  local tmp_file = vim.fn.stdpath("config") .. "/template/skeleton.cpp"
  vim.cmd("0read " .. tmp_file)

  -- Define the substitution dictionary
  local subst_dict = {
    filename = vim.fn.expand("%"), -- Current filename
    date = tostring(os.date("%Y %b %d %X")), -- Current date and time
  }

  -- Perform substitutions one by one
  for key, value in pairs(subst_dict) do
    local pattern = string.format("<<%s>>", key)
    vim.cmd(string.format("%%s/%s/%s/g", pattern, vim.fn.escape(value, "/")))
  end

  -- Set the buffer as unmodified
  vim.bo.modified = false

  -- Move the cursor to the first line
  vim.cmd("normal gg")

  -- Move the cursor to line 13
  vim.cmd("normal 12G")
  vim.cmd("w")
end

return M
