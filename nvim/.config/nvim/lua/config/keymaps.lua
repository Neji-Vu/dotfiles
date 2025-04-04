local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "tn", ":tabnext<Return>", opts)
keymap.set("n", "tp", ":tabprev<Return>", opts)

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
keymap.set("n", "\\j", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap.set("n", "\\k", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap.set("i", "\\j", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "\\k", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "\\j", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "\\k", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Diagnostics
keymap.set("n", "<C-n>", function()
  vim.diagnostic.goto_next()
end, opts)
keymap.set("n", "<C-p>", function()
  vim.diagnostic.goto_prev()
end, opts)
