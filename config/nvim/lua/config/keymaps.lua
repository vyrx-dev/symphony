-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap helper
local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- jj to escape insert mode
set("i", "jj", "<Esc>", opts)

-- Disable the spacebar key's default behavior in Normal and Visual modes
set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Split window
set("n", "ss", ":split<Return>", opts)
set("n", "sv", ":vsplit<Return>", opts)
set("n", "sx", "<cmd>close<CR>", opts)

-- Make current file executable
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Jumping
set({ "n", "o", "x" }, "<s-h>", "^", { desc = "Jump to beginning of line" })
set({ "n", "o", "x" }, "<s-l>", "g_", { desc = "Jump to end of line" })

-- Copy file paths
set("n", "<leader>cf", '<cmd>let @+ = expand("%")<CR>', { desc = "Copy File Name" })

-- live-server
set("n", "<leader>ps", ":LiveServerStart<CR>", { desc = "Start Live Server" })
set("n", "<leader>pe", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

-- file-explorer
set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Nvim tree " })

-- Center the screen after scrolling up/down with Ctrl-u/d
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")
set("n", "n", "nzzzv", opts)
set("n", "N", "Nzzzv", opts)

-- Stay in indent mode
set("v", "<", "<gv", opts)
set("v", ">", ">gv", opts)

-- Toggle line wrapping
set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- save, quit
set("n", "<leader>w", "<cmd> w <cr>", opts)
set("n", "<leader>sn", ":<cmd>noautocmd w <cr>", opts)

-- move a blocks of text up/down with K/J in visual mode
set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- delete single character without copying into register
set("n", "x", '"_x', opts)

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

-- Lazy and Mason
set("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })
set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Open Mason LSP installer" })

-- Toggle autoformat on save
set("n", "<leader>tf", ":ToggleAutoformat<CR>", { desc = "Toggle format on save" })

-- Markdown render
set("n", "<leader>pt", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })

-- Flutter watch
set("n", "<leader>ff", "<cmd>silent !tmux new-window -n flutter-run -c %:p:h && tmux send-keys 'flutter-watch' Enter<CR>", { desc = "Flutter watch" })
