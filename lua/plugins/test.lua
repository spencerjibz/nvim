return {
    {
        "nvim-neotest/neotest",
        -- Load only for common test filetypes to avoid unnecessary startup cost
        ft = { "rust", "lua", "python", "go", "javascript", "typescript" },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Use a maintained Rust adapter for neotest to avoid rustaceanvim adapter issues
            "rouge8/neotest-rust",
        },
        config = function()
            local adapters = {}

            -- Prefer the dedicated neotest-rust adapter (stable and maintained)
            local ok_rust, neotest_rust = pcall(require, "neotest-rust")
            if ok_rust and neotest_rust then
                table.insert(adapters, neotest_rust)
            end

            -- Only use the maintained neotest-rust adapter to avoid junit/xml issues

            require("neotest").setup {
                adapters = adapters,
                log_level = vim.log.levels.ERROR,
                quickfix = { enabled = false },
                -- Avoid automatically opening the summary (some neotest versions
                -- may have a broken window opener in this environment)
                summary = { open = false },
                -- Don't open output automatically to avoid window/open issues
                output = { enabled = true, open_on_run = false },
                icons = { running = "", passed = "", failed = "", skipped = "" },
            }

            -- Note: keymaps for neotest are intentionally not set here to preserve
            -- existing mappings defined elsewhere in the configuration.
        end,
    },
}
