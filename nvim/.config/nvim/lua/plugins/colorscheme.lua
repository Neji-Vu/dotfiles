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
    -- opts.sidebars = { "terminal", "noice" }
    opts.on_highlights = function(hl, c)
      hl.CursorLineNr = { fg = c.cyan } -- The current number line
      hl.LineNr = { fg = c.cyan700 } -- The other number lines
      -- hl.cursorline = { fg = c.base04 } -- the other number lines
      hl.Visual = { bg = c.cyan700 }
      hl.WinSeparator = { fg = c.cyan700 }
      hl.SnacksDashboardHeader = { fg = c.cyan500 } -- The header color of snacks
      hl.TelescopeBorder = { fg = c.cyan700, bg = c.bg_float }
      hl.WhichKeyBorder = { fg = c.cyan700, bg = c.bg_float }

      hl.NotifyBackground = { fg = c.fg, bg = c.bg_float }
      --- --- Border
      --- hl.NotifyERRORBorder = { fg = Util.darken(c.error, 0.3), bg =  c.bg }
      --- hl.NotifyWARNBorder = { fg = Util.darken(c.warning, 0.3), bg =  c.bg }
      --- hl.NotifyINFOBorder = { fg = Util.darken(c.info, 0.3), bg =  c.bg }
      --- hl.NotifyDEBUGBorder = { fg = Util.darken(c.base01, 0.3), bg =  c.bg }
      --- hl.NotifyTRACEBorder = { fg = Util.darken(c.violet500, 0.3), bg =  c.bg }
      --- --- Icons
      --- hl.NotifyERRORIcon = { fg = c.error }
      --- hl.NotifyWARNIcon = { fg = c.warning }
      --- hl.NotifyINFOIcon = { fg = c.info }
      --- hl.NotifyDEBUGIcon = { fg = c.base01 }
      --- hl.NotifyTRACEIcon = { fg = c.violet500 }
      --- --- Title
      --- hl.NotifyERRORTitle = { fg = c.error }
      --- hl.NotifyWARNTitle = { fg = c.warning }
      --- hl.NotifyINFOTitle = { fg = c.info }
      --- hl.NotifyDEBUGTitle = { fg = c.base01 }
      --- hl.NotifyTRACETitle = { fg = c.violet500 }
      --- --- Body
      --- hl.NotifyERRORBody = { fg = c.fg, bg = opts.transparent and c.none or c.bg }
      --- hl.NotifyWARNBody = { fg = c.fg, bg = opts.transparent and c.none or c.bg }
      --- hl.NotifyINFOBody = { fg = c.fg, bg = opts.transparent and c.none or c.bg }
      --- hl.NotifyDEBUGBody = { fg = c.fg, bg = opts.transparent and c.none or c.bg }
      --- hl.NotifyTRACEBody = { fg = c.fg, bg = opts.transparent and c.none or c.bg }
    end
    opts.on_colors = function(colors)
      colors.bg_float = colors.base03
    end
  end,
}
