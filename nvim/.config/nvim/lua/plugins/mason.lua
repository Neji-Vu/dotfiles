return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "clangd", -- for c++
      -- "clang-format",
      "codelldb",
      "stylua",
      "luacheck",
      "shellcheck",
      "cmake-language-server",
    },
  },
}
