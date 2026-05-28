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
            -- Base configuration for neotest; adapters will be appended when available
            local base_config = {
                adapters = {},
                log_level = vim.log.levels.ERROR,
                quickfix = { enabled = false },
                summary = { open = true },
                output = { enabled = true, open_on_run = true },
                icons = { running = "", passed = "", failed = "", skipped = "" },
            }

            -- Try to require the rust adapter now; if it's not available yet, register
            -- an autocmd to try again when Rust files are opened.
            local ok, rust_adapter = pcall(require, "rustaceanvim.neotest")
            if ok and rust_adapter then
                -- Create a safe proxy around the adapter to ensure required fields exist.
                local proxy = setmetatable({}, { __index = rust_adapter })

                if type(rust_adapter.results) == "function" then
                    proxy.results = vim.schedule_wrap(rust_adapter.results)
                else
                    -- Provide a no-op results function to avoid neotest indexing nil
                    proxy.results = function()
                        return {}
                    end
                end

                table.insert(base_config.adapters, proxy)
                require("neotest").setup(base_config)
            else
                -- First call setup without the rust adapter
                require("neotest").setup(base_config)

                -- Attempt to load the rust adapter later when Rust files are in use
                local group = vim.api.nvim_create_augroup("NeotestRustAdapter", { clear = true })
                vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
                    pattern = "*.rs",
                    group = group,
                    callback = function()
                        local ok2, rust_adapter2 = pcall(require, "rustaceanvim.neotest")
                        if ok2 and rust_adapter2 then
                            local proxy2 = setmetatable({}, { __index = rust_adapter2 })
                            if type(rust_adapter2.results) == "function" then
                                proxy2.results = vim.schedule_wrap(rust_adapter2.results)
                            else
                                proxy2.results = function()
                                    return {}
                                end
                            end
                            -- Reconfigure neotest to include the rust adapter
                            local current = require("neotest").config or {}
                            local adapters = current.adapters or {}
                            table.insert(adapters, proxy2)
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
