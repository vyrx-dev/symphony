-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymap helper
local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Split window
set("n", "ss", ":split<Return>", opts)
set("n", "sv", ":vsplit<Return>", opts)
set("n", "sx", "<cmd>close<CR>", opts)


set("n", "<leader>el", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader>ef", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- live-server
set("n", "<leader>ps", ":LiveServerStart<CR>", { desc = "Start Live Server" })
set("n", "<leader>pe", ":LiveServerStop<CR>", { desc = "Stop Live Server" })
set("n", ";f", ":Oil<CR>", { desc = "oil explorer" })

-- Center the screen after scrolling up/down with Ctrl-u/d
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")
set("n", "n", "nzzzv", opts)
set("n", "N", "Nzzzv", opts)

-- Stay in indent mode
set('v', '<', '<gv', opts)
set('v', '>', '>gv', opts)

-- Toggle line wrapping
set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- save, quit
set("n", "<leader>w", "<cmd> w <cr>" , opts)
set("n", "<leader>sn", ":<cmd>noautocmd w <cr>" , opts)
set("n", "<leader>c", "<cmd> q <cr>" ,opts)

-- move a blocks of text up/down with K/J in visual mode
set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- Toggle Screenkey
set("n", "<leader>vk", "<cmd>Screenkey<CR>", opts)

-- Select all
set("n", "<C-a>", "gg<S-v>G")

-- delete single character without copying into register
set('n', 'x', '"_x', opts)

-- search and replace the word under cursor in the file with <leader>s
set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- lazygit
set("n", "<leader>gg", ":LazyGit<CR>", opts)

-- Disable continuations
set("n", "<Leader>o", "o<Esc>^Da", opts)
set("n", "<Leader>O", "O<Esc>^Da", opts)

-- delete without yanking
set({ "n", "v" }, "<leader>d", [["_d]])

-- Paste in visual mode without yanking replaced text
set("x", "p", [["_dP]])

-- CopilotChat
set("n", "tc", ":CopilotChatSave ")
set("n", "tl", ":CopilotChatLoad ")
set("n", "tp", ":CopilotChatPrompts")

-- Resize window
set("n", "<leader><left>", ":vertical resize +20<cr>")
set("n", "<leader><right>", ":vertical resize -20<cr>")
set("n", "<leader><up>", ":resize +10<cr>")
set("n", "<leader><down>", ":resize -10<cr>")

-- Buffers
set("n", "<Tab>", ":bnext<cr>", opts)
set("n", "<S-Tab>", ":bprevious<cr>", opts)
set("n", "<leader>bd", ":bdelete!<cr>", opts) --close buffer
set("n", "<leader>bn", "<cmd> enew <cr>", opts) -- new buffer

-- Diagnostic 
set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Save and load session
set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false })
set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false })
