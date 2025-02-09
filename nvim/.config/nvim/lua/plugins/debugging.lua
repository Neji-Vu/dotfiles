return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()

    vim.keymap.set("n", "<Leader>dn", "<cmd>DapNew<CR>", { desc = "Launch New session" })
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<Leader>dT", dap.clear_breakpoints, { desc = "Clear breakpoints" })
    vim.keymap.set("n", "<Leader>ds", "<cmd>DapTerminate<CR>", { desc = "Close session" })

    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<Leader>de", dap.step_out, { desc = "Step out" })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    local mason_registry = require("mason-registry")
    local package = mason_registry.get_package("codelldb")
    local codelldb_path = package:get_install_path()

    dap.adapters.codelldb = {
      type = "executable",
      command = codelldb_path .. "/codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

      -- On windows you may have to uncomment this:
      -- detached = false,
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/output/" .. vim.fn.expand("%:r"), "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        preLaunchTask = function()
          local compile_cmd = "g++ -g -std=c++11 " .. vim.fn.expand("%") .. " -o output/" .. vim.fn.expand("%:r") -- Modify as needed
          print("Compiling: " .. compile_cmd)
          os.execute(compile_cmd)
        end,
      },
    }
  end,
}
