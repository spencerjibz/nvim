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

            -- Fall back to rustaceanvim adapter only if available and seems healthy
            local ok_ra, ra_adapter = pcall(require, "rustaceanvim.neotest")
            if ok_ra and ra_adapter and type(ra_adapter.results) == "function" then
                -- schedule any UI-calling results function
                ra_adapter.results = vim.schedule_wrap(ra_adapter.results)
                table.insert(adapters, ra_adapter)
            end

            require("neotest").setup {
                adapters = adapters,
                log_level = vim.log.levels.ERROR,
                quickfix = { enabled = false },
                summary = { open = true },
                output = { enabled = true, open_on_run = true },
                icons = { running = "", passed = "", failed = "", skipped = "" },
            }

            -- Note: keymaps for neotest are intentionally not set here to preserve
            -- existing mappings defined elsewhere in the configuration.
        end,
    },
}
