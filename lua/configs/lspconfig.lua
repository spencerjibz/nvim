-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "lua_ls", "html", "cssls", "ts_ls", "tailwindcss", "yamlls", "emmet_ls", "taplo", "eslint", "clangd" }
local nvlsp = require "nvchad.configs.lspconfig"

-- local util = require "lspconfig/util"
-- lsps with default config

for _, lsp in ipairs(servers) do
  local opts = {
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    on_attach = nvlsp.on_attach,
  }

  if lsp == "clangd" then
    opts.on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      nvlsp.on_attach(client, bufnr)
    end
    opts.init_options = {
      fallbackFlags = { "-std=c++20" },
    }
    opts.cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      -- Updated with your specific 2025 version paths
      "--query-driver=C:/msys64/mingw64/bin/g++.exe,C:/Program Files (x86)/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX86/x86/cl.exe",
      "--fallback-style=llvm",
    }
  end
  lspconfig[lsp].setup(opts)
end
-- Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX86/x86/cl

-- -- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   filetypes = { "typescript", "javascript", "text" },
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
