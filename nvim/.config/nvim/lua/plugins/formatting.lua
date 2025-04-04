return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cpp = { "clang_format" },
      c = { "clang_format" },
    },
    formatters = {
      clang_format = {
        prepend_args = {
          -- IndentWidth = 4
          -- TabWidth = 4
          -- UseTab = Always
          -- AllowShortFunctionsOnASingleLine: Empty
          -- ColumnLimit: 95
          "--style=file:"
            .. vim.fn.stdpath("config")
            .. "/template/.clang-format",
        },
      },
    },
  },
}
