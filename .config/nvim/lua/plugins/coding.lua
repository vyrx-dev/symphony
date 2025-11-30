return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- split and join
  {
    "Wansmer/treesj",
    keys = { "<space>m" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup { max_join_length = 200 }
    end,
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = false,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-l>",
          accept_line = "<M-S-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
      mappings = {
        reset = {
          insert = "<C-c>",
          normal = "<C-c>",
        },
      },
      prompts = {
        Tutor = {
          prompt = "You are an AI coding instructor designed to assist and guide me as I learn to code. Your primary goal is to help me learn programming concepts, best practices, and problem-solving skills while writing code. Always assume I'm a beginner with limited programming knowledge.Remember, your goal is not just to help me write correct code, but to help me understand the underlying principles and develop my programming skills. Always strive to be clear, patient, and encouraging in your responses.",
        },
        Feedback = {
          prompt = "Review the code and provide feedback. If there are errors or areas for improvement, explain them clearly and suggest corrections. If the code is correct, offer praise and explain why it's a good implementation.Structure your responses as follows: 1- Answer my question, 2- Code review and feedback, 3- Suggestions for further learning or practice",
        },
        FixBuffer = {
          prompt = "Given these diagnostics in the file '$file' which is a '$language' file, please fix the issues: $diagnostics",
        },
      },
    },
    keys = {
      { "<leader>a", "<cmd>CopilotChat<CR>", mode = "n", desc = "Open Copilot Chat" },
      { "<leader>te", "<cmd>CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
      { "<leader>tr", "<cmd>CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
      { "<leader>tf", "<cmd>CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
      { "<leader>to", "<cmd>CopilotChatOptimize<Cr>", mode = "v", desc = "Optimize Code" },
      { "<leader>td", "<cmd>CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
      { "<leader>tt", "<cmd>CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
      { "<leader>tm", "<cmd>CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
      { "<leader>ts", "<cmd>CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
    },
  },
}
