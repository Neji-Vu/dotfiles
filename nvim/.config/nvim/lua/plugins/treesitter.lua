return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    ensure_installed = {
      "cmake",
      "cpp",
      "c",
      "fish",
      "gitignore",
      "json",
      "bash",
      "lua",
      "vim",
    },
  },
  config = function(_, opts)
    -- import nvim-treesitter plugin
    require("nvim-treesitter.configs").setup(opts)
    -- setup for rainbow-delimiters
    require("rainbow-delimiters.setup").setup({
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
        lua = 210,
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    })
  end,
}
