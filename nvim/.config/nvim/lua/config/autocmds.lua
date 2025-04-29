local cpp = require("manhcuong.relatedCpp")

local discipline = require("manhcuong.discipline")

discipline.cowboy()

-- Apply for cpp file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    cpp.BuildKeymap() -- press <leader>cb to build cpp file
    cpp.RunKeymap() -- press <leader>ce or <leader>cE to run cpp file
    cpp.EditInputFileKeymap() -- press <leader>ci to edit input file
  end,
})

-- Apply for new cpp file
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    cpp.GenerateCppFile() -- automatically gen new cpp file with the skeleton
  end,
})
