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
map("n", "<Leader>o", "o<Esc>^Da")
map("n", "<Leader>O", "O<Esc>^Da")

-- New tab

map("n", "te", ":tabedit")
map("n", "<tab>", ":tabnext<Return>")
map("n", "<s-tab>", ":tabprev<Return>")
-- Move window
