local options = {
  formatters_by_ft = {
    ["typescript"] = { "prettier" },
    ["javascript"] = { "prettier" },
    ["html"] = { "prettier" },
    ["json"] = { "prettier" },
    ["lua"] = { "stylua" },
    ["markdown"] = { "prettier" },
    ["yaml"] = { "prettier" },
    ["jsx"] = { "prettier" },
    rust = { "rust-fmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 300,
    lsp_fallback = true,
  },
}

return options
