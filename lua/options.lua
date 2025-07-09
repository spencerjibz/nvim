require "nvchad.options"

-- add yours here!
local o = vim.o
-- .cursorlineopt ='both' -- to enable cursorline!
o.undofile = true
o.breakindent = true
o.relativenumber = true
-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = true
vim.g.have_nerd_font = true
if vim.g.started_by_firenvim == 1 then
  vim.g.auto_session_enabled = false
end
