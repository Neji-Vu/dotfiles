local cpp = require("manhcuong.relatedCpp")

local discipline = require("manhcuong.discipline")

discipline.cowboy()

-- Apply for cpp file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    cpp.BuildCppFile() -- press <leader>7 to build cpp file
    cpp.RunCppFile() -- press <leader>8 to run cpp file
  end,
})

-- Apply for new cpp file
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    cpp.GenerateCppFile() -- automatically gen new cpp file with the skeleton
  end,
})
