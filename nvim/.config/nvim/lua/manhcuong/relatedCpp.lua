local M = {}

local myfunc = require("manhcuong.myfunc")

function M.MakeDirOSCmd()
  -- A command to make the output folder holding the executable files
  local flag = myfunc.os_name() == "Windows" and "-f" or "-p"
  local suppress = myfunc.os_name() == "Windows" and "$null" or "/dev/null"
  return string.format("mkdir %s output > %s", flag, suppress)
end

function M.BuildCppFileInVim()
  local filename = vim.fn.expand("%")
  local out_path = "output/" .. vim.fn.expand("%:r")
  -- g++ -o output/test test.cpp -std=c++17
  return string.format("g++ -o %s %s -std=c++17", out_path, filename)
end

function M.BuildCppFileInOS()
  local filename = vim.fn.expand("%")
  local out_path = "output/" .. vim.fn.expand("%:r")

  return {
    "g++",
    "-o",
    out_path,
    filename,
    "-std=c++17",
  }
end

------------------------------------------------------------------------

function M.RunInNewWindow()
  -- Split window to show the output of build result
  vim.cmd("split")
  vim.cmd("te ./output/%:r")

  -- change the window to insert mode to enter input
  vim.api.nvim_feedkeys("i", "n", false)
end

function M.BuildInNewWindow()
  -- A command to make the output folder holding the executable files
  os.execute(M.MakeDirOSCmd())

  -- Split window to show the output of build result
  vim.cmd("w")
  vim.cmd("split")

  -- Build cpp file in the new window
  local gcc_cmd = string.format("te %s", M.BuildCppFileInVim())
  vim.cmd(gcc_cmd)

  -- change the window to insert mode to enter input
  -- vim.api.nvim_feedkeys("i", "n", false)
end

function M.RunWithoutInputFile()
  -- File is not saved
  if vim.bo.modified then
    -- A command to make the output folder holding the executable files
    os.execute(M.MakeDirOSCmd())

    -- Split window to show the output of build result
    vim.cmd("w")

    -- build and show output to message
    vim.fn.jobstart(M.BuildCppFileInOS(), {
      on_exit = function(_, code)
        if code == 0 then
          print("✅ Build successful!")
          M.RunInNewWindow()
        else
          print("❌ Build failed!")
        end
      end,
    })
  else
    M.RunInNewWindow()
  end
end

------------------------------------------------------------------------

function M.BuildKeymap()
  vim.keymap.set("n", "<leader>cb", function()
    M.BuildInNewWindow()
  end, { desc = "Build cpp file", noremap = true, silent = true })
end

function M.RunKeymap()
  vim.keymap.set("n", "<leader>ce", function()
    M.RunWithoutInputFile()
  end, { desc = "Execute cpp file", noremap = true, silent = true })

  local command_file = ":split<CR>:te ./output/%:r < output/input.txt<CR>i"
  vim.keymap.set("n", "<leader>cE", function()
    local input_file = "output/input.txt"
    if vim.fn.filereadable(input_file) == 1 then
      --- file exists
      print("exist")

      -- run execution file
      os.execute("./output/" .. vim.fn.expand("%:r") .. " < output/input.txt > output/output.txt")

      -- show the input and output file
      vim.cmd("sp output/input.txt")
      vim.cmd("vs output/output.txt")
      vim.cmd("resize 12")

      -- move the cursor to the main window
      vim.cmd("wincmd k")
    else
      -- does not exist
      print("Input file does not exist!")

      -- os.execute("touch output/input.txt")
      vim.cmd("sp output/input.txt")
      vim.cmd("resize 12")
    end
  end, { desc = "Execute cpp file with input file", noremap = true, silent = true })
end

------------------------------------------------------------------------

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
