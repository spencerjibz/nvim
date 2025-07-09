return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- lazy-load on Copilot command
    build = ":Copilot auth", -- automatically run auth if needed
    event = "InsertEnter", -- or "VeryLazy" to load a bit later
    config = function()
      require("copilot").setup {
        suggestion = { enabled = true },
        panel = { enabled = true },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "jsx", "html", "typescript", "tsx" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    lazy = false,
    opts = require "configs.conform",
  },

  { "glacambre/firenvim", build = ":call firenvim#install(0)", lazy = false },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    Lazy = false,
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    -- or                              , branch = '0.1.x',
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "https://git.sr.ht/~nedia/auto-save.nvim",
    event = { "BufReadPre" },
    opts = {
      events = { "InsertLeave", "BufLeave" },
      silent = false,
      exclude_ft = { "neo-tree" },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Use stable version
    lazy = false,
    ft = { "rust", "text" }, -- Load only for Rust files
    config = function()
      local mason_path = vim.fn.stdpath "data" .. "/mason"
      local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"
      local liblldb_path = codelldb_path .. "lldb/lib/liblldb.dylib" -- Change for your OS
      local cfg = require "rustaceanvim.config"
      if vim.loop.os_uname().sysname == "Linux" then
        liblldb_path = codelldb_path .. "lldb/lib/liblldb.so"
      elseif vim.loop.os_uname().sysname == "Windows_NT" then
        liblldb_path = codelldb_path .. "lldb\\bin\\liblldb.dll"
      end

      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              -- checkOnSave = { command = "clippy" },
              -- diagnostics = { enable = true },
            },
          },
          dap = {
            adapter = cfg.get_codelldb_adapter(codellb_path, liblldb_path),
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    ft = { "rust", "toml" },
    config = function(opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
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
    end,
  },
  {
    "Canop/nvim-bacon",
    lazy = false,
    config = function()
      require("bacon").setup {
        quickfix = {
          enabled = true, -- Enable Quickfix integration
          event_trigger = true, -- Trigger QuickFixCmdPost after populating Quickfix list
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "tsx",
        "typescript",
        "javascript",
        "html",
        "css",
        "json",
        "lua",
        "vim",
        "vimdoc",
        "rust",
        "toml", -- optional, useful for Cargo.toml
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
  },
}
