-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local pacekeeper = require("doublek.pacekeeper")
pacekeeper.chill()

-- Keymap helper
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- -- markdown preview
-- vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>") -- using peek.nvim

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Center the screen after scrolling up/down with Ctrl-u/d
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-d>", "<C-d>zz")

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

keymap.set("n", "<leader>ha", mark.add_file, opts) -- Harpoon add
keymap.set("n", "<leader>h", ui.toggle_quick_menu, opts) -- Harpoon menu
keymap.set("n", "hp", ui.nav_next, opts) -- Harpoon next file
keymap.set("n", "hn", ui.nav_prev, opts) -- Harpoon previous

keymap.set("n", "<leader>1", function()
  ui.nav_file(1)
end, opts)
keymap.set("n", "<leader>2", function()
  ui.nav_file(2)
end, opts)
keymap.set("n", "<leader>3", function()
  ui.nav_file(3)
end, opts)
keymap.set("n", "<leader>4", function()
  ui.nav_file(4)
end, opts)

-- save, quit
keymap.set("n", "<leader>w", ":w<cr>")
keymap.set("n", "<leader>c", ":q<cr>")

-- move a blocks of text up/down with K/J in visual mode
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- change inner word
vim.keymap.set("n", "<C-c>", "ciw")

-- jj to escape insert mode
keymap.set("i", "jj", "<Esc>", opts)

-- Toggle Screenkey
keymap.set("n", "<leader>vk", "<cmd>Screenkey<CR>", opts)

--live server
keymap.set("n", "<C-g>", "<cmd>terminal live-server<CR>", opts)

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- zen mode
--keymap.set("n", "<leader>zm", ":ZenMode<cr>")

-- delete without yanking
keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- search and replace the word under cursor in the file with <leader>s
keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Paste in visual mode without yanking replaced text
keymap.set("x", "p", [["_dP]])

-- Tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "tx", "<cmd>tabclose<CR>", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "sx", "<cmd>close<CR>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<leader><left>", ":vertical resize +20<cr>")
keymap.set("n", "<leader><right>", ":vertical resize -20<cr>")
keymap.set("n", "<leader><up>", ":resize +10<cr>")
keymap.set("n", "<leader><down>", ":resize -10<cr>")

-- Diagnostics

-- Go to next diagnostic
keymap.set("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, opts)

--[[Notes
count = 1 → moves to next diagnostic
count = -1 → moves to previous diagnostic
float = true → shows a floating window with the error/warning message
]]
