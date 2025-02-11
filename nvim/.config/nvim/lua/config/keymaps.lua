local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "sc", "<C-w>q") -- close the current window without deleting the buffer
keymap.set("n", "sx", "<Cmd>:bd<CR>") -- close and deleting the current window and buffer (without saving)
keymap.set("n", "se", "<C-w>x") --exchange current window  with next one

-- move selected lines
keymap.set("n", "<A-J>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-K>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap.set("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<A-J>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<A-K>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- esc and c-[ to escape terminal mode
function _G.set_terminal_keymaps()
  local term_opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], term_opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], term_opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], term_opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], term_opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], term_opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = [[term://*]],
  callback = set_terminal_keymaps,
})
-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
