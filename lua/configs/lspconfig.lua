-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "lua_ls", "html", "cssls", "ts_ls", "tailwindcss", "yamlls", "emmet_ls", "taplo", "eslint" }
local nvlsp = require "nvchad.configs.lspconfig"

-- local util = require "lspconfig/util"
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- -- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   filetypes = { "typescript", "javascript", "text" },
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
