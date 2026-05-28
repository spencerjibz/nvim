require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>br", ":Bacon<CR>", { desc = "Run Bacon" })
map("n", "<leader>bb", ":BaconNext<CR>", { desc = "Next Bacon Error" })
map("n", "<leader>bp", ":BaconPrev<CR>", { desc = "Previous Bacon Error" })
map("n", "<leader>bl", ":BaconList<CR>", { desc = "List Bacon Errors" })
map("n", "<leader>bt", ":BaconToggle<CR>", { desc = "Toggle Bacon" })

map("n", "<leader>rcu", function()
    require("crates").upgrade_all_crates()
end, { desc = "Update all dependencies in toml file" })

--- key mappings for rust;
---
-- Disable continuations
--
map("n", "<Leader>o", "o<Esc>^Da")
map("n", "<Leader>O", "O<Esc>^Da")
map("n", "<leader>me", function()
    vim.cmd.RustLsp "expandMacro"
end, { desc = "Rust: Expand Macro" })

-- New tab

map("n", "te", ":tabedit")
map("n", "<tab>", ":tabnext<Return>")
map("n", "<s-tab>", ":tabprev<Return>")
-- Move window

-- Mappings for quick fix list
map("n", "<M-J>", "<cmd> cnext<CR>")
map("n", "<M-K>", "<cmd> cprev<CR>")
-- Neo tests mappings (safe with error handling)
map("n", "<leader>tr", function()
    -- Ensure neotest is configured to use neotest-rust adapter to avoid rustaceanvim adapter crashes
    local ok_setup = pcall(function()
        local ok_rust, neotest_rust = pcall(require, "neotest-rust")
        if ok_rust and neotest_rust then
            pcall(require("neotest").setup, { adapters = { neotest_rust } })
        end
    end)

    local ok = pcall(function()
        require("neotest").run.run()
    end)
    if not ok then
        vim.schedule(function()
            vim.notify("neotest: failed to run nearest test", vim.log.levels.WARN)
        end)
    end
end, { desc = "Run Nearest Test" })
map("n", "<leader>tf", function()
    -- Ensure neotest uses neotest-rust
    pcall(function()
        local ok_rust, neotest_rust = pcall(require, "neotest-rust")
        if ok_rust and neotest_rust then
            pcall(require("neotest").setup, { adapters = { neotest_rust } })
        end
    end)

    local ok = pcall(function()
        require("neotest").run.run(vim.fn.expand "%")
    end)
    if not ok then
        vim.schedule(function()
            vim.notify("neotest: failed to run file tests", vim.log.levels.WARN)
        end)
    end
end, { desc = "Run File Tests" })
map("n", "<leader>ts", function()
    local ok = pcall(function()
        require("neotest").summary.toggle()
    end)
    if not ok then
        vim.schedule(function()
            vim.notify("neotest: failed to toggle summary", vim.log.levels.WARN)
        end)
    end
end, { desc = "Toggle Test Summary" })
map("n", "<leader>to", function()
    local ok = pcall(function()
        require("neotest").output.open { enter = true }
    end)
    if not ok then
        vim.schedule(function()
            vim.notify("neotest: failed to open output", vim.log.levels.WARN)
        end)
    end
end, { desc = "Show Test Output" })
