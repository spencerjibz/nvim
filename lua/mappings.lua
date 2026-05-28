require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>pr", '"_dP')
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
-- Neo tests mappings (kept consistent with lua/plugins/test.lua)
map("n", "<leader>tn", function()
    require("neotest").run.run()
end, { desc = "Run Nearest Test" })
map("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run File Tests" })
map("n", "<leader>ts", function()
    require("neotest").run.stop()
end, { desc = "Stop Running Tests" })
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
map("n", "<leader>tS", function()
    local ok, summary = pcall(require, "neotest.summary")
    if not ok then
        -- Attempt to lazily load neotest plugins then retry
        pcall(function()
            local ok_lazy, lazy = pcall(require, "lazy")
            if ok_lazy and lazy and lazy.load then
                lazy.load({ plugins = { "nvim-neotest/neotest", "rouge8/neotest-rust" } })
            end
        end)

        -- try requiring again after allowing lazy to load
        ok, summary = pcall(require, "neotest.summary")
        if not ok then
            vim.schedule(function()
                vim.notify("neotest: summary module not available (failed to lazy-load)", vim.log.levels.WARN)
            end)
            return
        end
    end

    -- Try to open the summary and then move it to a right vertical panel like neo-tests
    local opened, err = pcall(summary.open, { enter = true })
    if not opened then
        vim.schedule(function()
            vim.notify("neotest: failed to open summary: " .. tostring(err), vim.log.levels.WARN)
        end)
        return
    end

    -- Move the newly opened summary window to the far right and set width
    vim.defer_fn(function()
        pcall(vim.cmd, "wincmd L")
        pcall(vim.cmd, "vertical resize 45")
    end, 80)
end, { desc = "Toggle Test Summary (right panel)" })
