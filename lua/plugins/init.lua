return {
    { import = "nvchad.blink.lazyspec" },

    -- GitHub Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",         -- lazy-load on Copilot command
        build = ":Copilot auth", -- automatically run auth if needed
        event = "InsertEnter",
        config = function()
            require("copilot").setup {
                suggestion = { enabled = true },
                panel = { enabled = true },
            }
        end,
    },

    -- Copilot + nvim-cmp integration
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- Autotag for TSX/HTML
    {
        "windwp/nvim-ts-autotag",
        ft = { "jsx", "html", "typescript", "tsx" },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Formatter (loads on BufWritePre)
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        -- load lazily on BufWritePre
        lazy = true,
        opts = require "configs.conform",
    },

    { "glacambre/firenvim",            build = ":call firenvim#install(0)", lazy = false },

    -- LSP config
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
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

    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup {
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown() },
                },
            }

            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "ui-select")

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

            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = "[/] Fuzzily search in current buffer" })

            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                }
            end, { desc = "[S]earch [/] in Open Files" })

            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files { cwd = vim.fn.stdpath "config" }
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },

    -- Rust filetype plugin (fix lazy flag)
    {
        "rust-lang/rust.vim",
        ft = "rust",
        lazy = false,
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
        "https://git.sr.ht/~nedia/auto-save.nvim",
        event = { "BufReadPre" },
        opts = {
            events = { "InsertLeave", "BufLeave" },
            silent = false,
            exclude_ft = { "neo-tree" },
        },
    },

    -- rustaceanvim (fix codelldb path handling and adapter name)
    {
        "mrcjkb/rustaceanvim",
        version = "^8",
        lazy = false,
        ft = { "rust", "text" },
        config = function()
            local mason_path = vim.fn.stdpath "data" .. "/mason"
            local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"
            -- Default lib path (macOS), adjust for Linux/Windows below
            local liblldb_path = mason_path .. "/packages/codelldb/extension/lldb/lib/liblldb.dylib"

            local cfg = require "rustaceanvim.config"
            local sysname = vim.loop.os_uname().sysname
            if sysname == "Linux" then
                liblldb_path = mason_path .. "/packages/codelldb/extension/lldb/lib/liblldb.so"
            elseif sysname == "Windows_NT" then
                liblldb_path = mason_path .. "/packages/codelldb/extension/lldb/bin/liblldb.dll"
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
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            procMacro = { enable = true },
                            checkOnSave = true,
                            diagnostics = { enable = true, experimental = { enable = true } },
                            completion = {
                                postfix = { enable = true },
                                autoimport = { enable = true },
                            },
                            lens = { enable = true },
                            hoverActions = { enable = true },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                closureReturnTypeHints = { enable = "always" },
                                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
                                maxLength = nil,
                            },
                            files = { excludeDirs = { "target" } },
                        },
                    },
                    dap = {
                        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                    },
                },
            }
        end,
    },

    -- crates.nvim (don't auto-show on load)
    {
        "saecki/crates.nvim",
        tag = "stable",
        ft = { "rust", "toml" },
        config = function(opts)
            local crates = require "crates"
            crates.setup(opts)
        end,
    },

    -- DAP UI and DAP
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
                    enabled = true,
                    event_trigger = true,
                },
            }
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.10.0",
        lazy = false,
        build = ":TSUpdate",
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
                "toml",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
        },
    },

    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
}
