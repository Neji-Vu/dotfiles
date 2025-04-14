local M = {}

local myfunc = require("manhcuong.myfunc")

local function get_current_file()
  return vim.fn.expand("%:p")
end

local function get_exec_file_full_path()
  return vim.fn.expand("%:p:h") .. "/output/" .. vim.fn.expand("%:t:r")
end

local function get_exec_file_rel_path()
  if vim.fn.expand("%:p:h") == vim.fn.getcwd() then
    return "/output/" .. vim.fn.expand("%:t:r")
  else
    return "/" .. vim.fn.expand("%:h") .. "/output/" .. vim.fn.expand("%:t:r")
  end
end

local function get_output_dir()
  return vim.fn.expand("%:p:h") .. "/output"
end

local function get_input_file()
  return vim.fn.expand("%:p:h") .. "/output/input.txt"
end

local function get_output_file()
  return vim.fn.expand("%:p:h") .. "/output/output.txt"
end

------------------------------------------------------------------------

local function MakeDirOSCmd()
  -- A command to make the output folder holding the executable files
  local flag = myfunc.os_name() == "Windows" and "-f" or "-p"
  local suppress = myfunc.os_name() == "Windows" and "$null" or "/dev/null"
  return string.format("mkdir %s %s > %s", flag, get_output_dir(), suppress)
end

local function BuildCppFileInVim()
  -- g++ -o output/test test.cpp -std=c++17
  return string.format("g++ -o %s %s -std=c++17", get_exec_file_full_path(), get_current_file())
end

local function BuildCppFileInOS()
  return {
    "g++",
    "-o",
    get_exec_file_full_path(),
    get_current_file(),
    "-std=c++17",
  }
end

------------------------------------------------------------------------

local function RunInNewWindow()
  -- Split window to show the output of build result
  vim.cmd("split")
  vim.cmd("te ." .. get_exec_file_rel_path())

  -- change the window to insert mode to enter input
  vim.api.nvim_feedkeys("i", "n", false)
end

local function BuildInNewWindow()
  -- A command to make the output folder holding the executable files
  os.execute(MakeDirOSCmd())

  -- Split window to show the output of build result
  vim.cmd("w")
  vim.cmd("split")

  -- Build cpp file in the new window
  local gcc_cmd = string.format("te %s", BuildCppFileInVim())
  vim.cmd(gcc_cmd)

  -- change the window to insert mode to enter input
  -- vim.api.nvim_feedkeys("i", "n", false)
end

local function RunWithoutInputFile()
  -- File is not saved
  -- if vim.bo.modified then

  -- A command to make the output folder holding the executable files
  os.execute(MakeDirOSCmd())
  vim.cmd("w")

  -- build and show output to message
  vim.fn.jobstart(BuildCppFileInOS(), {
    on_exit = function(_, code)
      if code == 0 then
        print("✅ Build successful!")
        RunInNewWindow()
      else
        print("❌ Build failed!")
      end
    end,
  })

  -- else
  --   RunInNewWindow()
  -- end
end

local function CreateInOutWindow()
  -- show the input and output file
  local input_file_path = get_input_file()
  local output_file_path = get_output_file()

  local exists_input, win_input = myfunc.is_file_open_in_window(input_file_path)
  local exists_output, win_output = myfunc.is_file_open_in_window(output_file_path)
  local keep_height_output_win_id = vim.api.nvim_get_current_win()

  if exists_input or exists_output then
    -- exists input and output window, do nothing
    if exists_output and exists_input then
      return win_output
    end

    -- exist input window
    if exists_input and win_input ~= nil then
      vim.api.nvim_set_current_win(win_input)
      vim.cmd("vs " .. output_file_path)
      keep_height_output_win_id = vim.api.nvim_get_current_win()
    end

    -- exist output window
    if exists_output and win_output ~= nil then
      vim.api.nvim_set_current_win(win_output)
      keep_height_output_win_id = vim.api.nvim_get_current_win()
      vim.cmd("vs " .. input_file_path)
      -- exchange the input and output windows
      vim.cmd("wincmd x")
    end
  else
    -- no window exists
    vim.cmd("sp " .. input_file_path)
    vim.cmd("vs " .. output_file_path)
    keep_height_output_win_id = vim.api.nvim_get_current_win()
  end

  -- keep the input/output window height fixed
  vim.wo[keep_height_output_win_id].winfixheight = true
  vim.api.nvim_win_set_height(keep_height_output_win_id, 12)

  -- move the cursor to the main window
  vim.cmd("wincmd k")
  return keep_height_output_win_id -- return win_id of output window
end

local function ShowResult()
  -- create and change the window
  local out_win = CreateInOutWindow()

  -- reload the content of output window
  local current_win = vim.api.nvim_get_current_win()
  if out_win ~= nil then
    vim.api.nvim_set_current_win(out_win)
  end
  vim.cmd("edit") -- force reload from disk
  vim.api.nvim_set_current_win(current_win) -- return to previous window
end

local function RunInNewInputOutputWindowAndTimeout(timeout_ms)
  -- run execution file
  local cmd = "." .. get_exec_file_rel_path() .. " < " .. get_input_file() .. " > " .. get_output_file()

  local job_id = vim.fn.jobstart({ "sh", "-c", cmd }, {
    on_exit = function(_, code)
      if code == 0 then
        ShowResult()
      end
    end,
  })

  vim.defer_fn(function()
    if vim.fn.jobwait({ job_id }, 0)[1] == -1 then
      vim.fn.jobstop(job_id)
      print("Timeout: Program killed.")
    end
  end, timeout_ms or 5000) -- 5000 ms = 5 seconds timeout
end

local function RunWithInputFile()
  -- file exists
  if vim.fn.filereadable(get_input_file()) == 1 then
    -- -- File is not saved
    -- if vim.bo.modified then

    -- Split window to show the output of build result
    vim.cmd("w")

    -- build and show output to message
    vim.fn.jobstart(BuildCppFileInOS(), {
      on_exit = function(_, code)
        if code == 0 then
          print("✅ Build successful!")
          RunInNewInputOutputWindowAndTimeout(3000)
        else
          print("❌ Build failed!")
        end
      end,
    })

    -- else
    --   RunInNewInputOutputWindowAndTimeout(3000)
    -- end
  else
    -- does not exist
    print("Input file does not exist!")

    -- os.execute("touch output/input.txt")
    vim.cmd("sp" .. get_input_file())
    vim.cmd("resize 12")
  end
end

------------------------------------------------------------------------

function M.BuildKeymap()
  vim.keymap.set("n", "<leader>cb", function()
    BuildInNewWindow()
  end, { desc = "Build cpp file", noremap = true, silent = true })
end

function M.RunKeymap()
  vim.keymap.set("n", "<leader>ce", function()
    RunWithoutInputFile()
  end, { desc = "Execute cpp file", noremap = true, silent = true })

  vim.keymap.set("n", "<leader>cE", function()
    RunWithInputFile()
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
