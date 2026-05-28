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
            "mrcjkb/rustaceanvim",
        },
        config = function()
            -- Build adapter list dynamically so missing adapters don't error
            local adapters = {}
            local ok, rust_adapter = pcall(require, "rustaceanvim.neotest")
            if ok and rust_adapter then
                -- Workaround: wrap `results` to avoid calling notify/echo in a fast event context
                if type(rust_adapter.results) == "function" then
                    rust_adapter.results = vim.schedule_wrap(rust_adapter.results)
                end
                table.insert(adapters, rust_adapter)
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
