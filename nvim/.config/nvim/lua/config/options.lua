local myfunc = require("manhcuong.myfunc")

vim.cmd("let g:netrw_liststyle = 3")

vim.g.mapleader = " "

local opt = vim.opt

opt.mouse = "a"
opt.foldlevelstart = 99
opt.wildmenu = true
opt.wildmode = { "list:longest", "full", "full" }
opt.wrap = false

opt.smartcase = true
opt.ignorecase = true

opt.splitbelow = true
opt.splitright = true

-- set up tabs
opt.expandtab = false
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4

-- Undercurl
vim.cmd([[let &t_Cs = "\e[6:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

if myfunc.osname() == "OSX" then
  opt.shell = "fish"
elseif myfunc.osname() == "Windows" then
  opt.shell = "pwsh"
  opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
  opt.shellxquote = ""
end
