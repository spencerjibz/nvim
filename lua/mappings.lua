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
    require("neotest").output.open { enter = true }
end, { desc = "Show Test Output" })
map("n", "<leader>tS", function()
    require("neotest").summary.toggle()
end, { desc = "Toggle Test Summary" })
