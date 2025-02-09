return {
  "craftzdog/solarized-osaka.nvim",
  lazy = true,
  priority = 1000,
  opts = function(_, opts)
    opts.transparent = true -- Enable built-in transparency if available
    opts.styles = {
      -- floats = "transparent",
      sidebars = "transparent",
    }
    opts.sidebars = { "terminal" }
    opts.on_highlights = function(hl, c)
      hl.CursorLineNr = { fg = c.cyan } -- The current number line
      hl.LineNr = { fg = c.cyan700 } -- The other number lines
      -- hl.cursorline = { fg = c.base04 } -- the other number lines
      hl.Visual = { bg = c.cyan700 }
      hl.WinSeparator = { fg = c.cyan700 }
      hl.SnacksDashboardHeader = { fg = c.cyan500 } -- The header color of snacks
    end
  end,
}
