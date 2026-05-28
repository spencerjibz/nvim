local options = {
  formatters_by_ft = {
    ["typescript"] = { "prettier" },
    ["javascript"] = { "prettier" },
    ["html"] = { "prettier" },
    ["json"] = { "prettier" },
    ["toml"] = { "taplo" },
    ["lua"] = { "stylua" },
    rust = { "rustfmt", lsp_format = "fallback" },
    ["markdown"] = { "prettier" },
    ["yaml"] = { "prettier" },
    ["jsx"] = { "prettier" },
  },
  formatters = {
    ["clang-format"] = {
      prepend_args = {
        "-style={ \
                IndentWidth: 4, \
                TabWidth: 4, \
                UseTab: Never, \
                AccessModifierOffset: 0, \
                IndentAccessModifiers: true, \
                PackConstructorInitializers: Never}",
      },
    },
  },
  format_after_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

return options
