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
            -- Use rustaceanvim's neotest adapter (preferred). Do NOT combine with neotest-rust.
            "mrcjkb/rustaceanvim",
        },
        config = function()
            local adapters = {}

            -- Try to require the rustaceanvim neotest adapter now
            local ok_ra, ra_adapter = pcall(require, "rustaceanvim.neotest")
            if ok_ra and ra_adapter and type(ra_adapter) == "table" then
                -- If the adapter exposes a results function, schedule it to avoid fast-event UI calls
                if type(ra_adapter.results) == "function" then
                    ra_adapter.results = vim.schedule_wrap(ra_adapter.results)
                end
                table.insert(adapters, ra_adapter)

                -- Register neotest immediately with rustaceanvim adapter
                require("neotest").setup {
                    adapters = adapters,
                    log_level = vim.log.levels.ERROR,
                    quickfix = { enabled = false },
                    summary = { open = false },
                    output = { enabled = true, open_on_run = false },
                    icons = { running = "", passed = "", failed = "", skipped = "" },
                }
            else
                -- If adapter isn't available yet (lazy load timing), setup neotest minimally
                require("neotest").setup {
                    adapters = {},
                    log_level = vim.log.levels.ERROR,
                    quickfix = { enabled = false },
                    summary = { open = false },
                    output = { enabled = true, open_on_run = false },
                    icons = { running = "", passed = "", failed = "", skipped = "" },
                }

                -- Try to attach the adapter later when Rust files are opened
                local group = vim.api.nvim_create_augroup("NeotestRustAdapter", { clear = true })
                vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
                    pattern = "*.rs",
                    group = group,
                    callback = function()
                        local ok2, ra2 = pcall(require, "rustaceanvim.neotest")
                        if ok2 and ra2 and type(ra2) == "table" then
                            if type(ra2.results) == "function" then
                                ra2.results = vim.schedule_wrap(ra2.results)
                            end
                            local current = require("neotest").config or {}
                            local adapters = current.adapters or {}
                            table.insert(adapters, ra2)
                            require("neotest").setup(vim.tbl_extend("force", current, { adapters = adapters }))
                            vim.api.nvim_clear_autocmds({ group = group })
                        end
                    end,
                })
            end

            -- Note: keymaps for neotest are intentionally not set here to preserve
            -- existing mappings defined elsewhere in the configuration.
        end,
    },
}
