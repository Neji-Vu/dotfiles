return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- skip no information available popup
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      -- enable border of noice
      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 7000,
    },
  },
}
