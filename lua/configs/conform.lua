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
    c_cpp = { "clang-format" },
    c = { "clang-format" },
    cpp = { "clang-format" },
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
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 300,
    lsp_fallback = true,
  },
}

return options
