-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- EXAMPLE
local servers = { "lua_ls", "html", "cssls", "ts_ls", "tailwindcss", "yamlls", "emmet_ls", "taplo", "eslint", "clangd" }
-- We no longer strictly need: local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

for _, lsp in ipairs(servers) do
  -- Start with the base configuration
  local config = {
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    on_attach = nvlsp.on_attach,
  }

  -- Language specific overrides
  if lsp == "clangd" then
    config.on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      nvlsp.on_attach(client, bufnr)
    end

    config.init_options = {
      fallbackFlags = { "-std=c++20" },
    }

    config.cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--query-driver=C:/msys64/mingw64/bin/g++.exe,C:/Program Files (x86)/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/HostX86/x86/cl.exe",
      "--fallback-style=llvm",
    }
  end

  -- Apply to the global vim.lsp.config table
  vim.lsp.config[lsp] = config

  -- Enable the server
  vim.lsp.enable(lsp)
end
