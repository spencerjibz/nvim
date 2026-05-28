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
            -- Rust adapters: prefer rustaceanvim integration but keep neotest-rust as a fallback
            "mrcjkb/rustaceanvim",
            "rouge8/neotest-rust",
        },
        config = function()
            local adapters = {}

            -- Try to load rustaceanvim's neotest adapter first (preferred integration)
            local ok_ra, ra_adapter = pcall(require, "rustaceanvim.neotest")
            if ok_ra and ra_adapter and type(ra_adapter) == "table" then
                -- Build a safe proxy that delegates to the real adapter but guards
                -- against nil 'results' and runtime errors coming from async contexts.
                local proxy = setmetatable({}, { __index = ra_adapter })

                -- Wrap results to avoid returning nil and to schedule UI calls safely
                if type(ra_adapter.results) == "function" then
                    proxy.results = function(...)
                        local ok, res = pcall(ra_adapter.results, ...)
                        if not ok or res == nil then
                            -- Return empty results to let neotest continue without error
                            return {}
                        end
                        return res
                    end
                else
                    proxy.results = function()
                        return {}
                    end
                end

                -- Wrap run to surface errors safely
                if type(ra_adapter.run) == "function" then
                    proxy.run = function(...)
                        local ok, err = pcall(ra_adapter.run, ...)
                        if not ok then
                            vim.schedule(function()
                                vim.notify("rustaceanvim.neotest.run failed: " .. tostring(err), vim.log.levels.ERROR)
                            end)
                        end
                        return err
                    end
                end

                table.insert(adapters, proxy)
            end

            -- Always add the maintained neotest-rust adapter as fallback
            local ok_nr, neotest_rust = pcall(require, "neotest-rust")
            if ok_nr and neotest_rust then
                table.insert(adapters, neotest_rust)
            end

            require("neotest").setup {
                adapters = adapters,
                log_level = vim.log.levels.ERROR,
                quickfix = { enabled = false },
                -- Don't open summary/output automatically; mappings handle UI
                summary = { open = false },
                output = { enabled = true, open_on_run = false },
                icons = { running = "", passed = "", failed = "", skipped = "" },
            }

            -- Note: keymaps for neotest are intentionally not set here to preserve
            -- existing mappings defined elsewhere in the configuration.
        end,
    },
}
