return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = {
    -- List all files in the current directory, except files listed in .gitignore
    {
      ";;",
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          no_ignore = false,
          hidden = true,
        })
      end,
      desc = "Lists files in your current working directory, respects .gitignore",
    },
    {
      ";g",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          -- Files starting with "." are included
          additional_args = { "--hidden" },
        })
      end,
      desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
    },
    {
      -- List all currently open buffers
      ";b",
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers()
      end,
      desc = "Lists open buffers",
    },
    {
      ";s",
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
    {
      -- Find helps of vim
      ";h",
      function()
        local builtin = require("telescope.builtin")
        builtin.help_tags()
      end,
      desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
    },
    {
      ";f",
      function()
        local telescope = require("telescope")

        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end

        telescope.extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = true,
          display_stat = false,
          initial_mode = "normal",
        })
      end,
      desc = "Open File Browser with the path of the current buffer",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions = require("telescope").extensions.file_browser.actions

    opts.defaults = {
      wrap_results = false,
      layout_strategy = "flex",
      layout_config = {
        prompt_position = "top",
        preview_cutoff = 30, -- the cutoff to switch layout direction
        flex = {
          flip_columns = 110, -- use horizontal layout if columns >= 100
        },
        horizontal = {
          preview_width = 0.5,
        },
        vertical = {
          preview_height = 0.4,
          mirror = true,
        },
      },
      sorting_strategy = "ascending",
      winblend = 5,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-y>"] = actions.select_default,
          ["<C-e>"] = actions.close,
          ["<C-l>"] = actions.preview_scrolling_right,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-f>"] = function(prompt_bufnr)
            for i = 1, 3 do
              actions.move_selection_next(prompt_bufnr)
            end
          end,
          ["<C-b>"] = function(prompt_bufnr)
            for i = 1, 3 do
              actions.move_selection_previous(prompt_bufnr)
            end
          end,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-y>"] = actions.select_default,
          ["<C-e>"] = actions.close,
          ["<C-l>"] = actions.preview_scrolling_right,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-f>"] = function(prompt_bufnr)
            for i = 1, 3 do
              actions.move_selection_next(prompt_bufnr)
            end
          end,
          ["<C-b>"] = function(prompt_bufnr)
            for i = 1, 3 do
              actions.move_selection_previous(prompt_bufnr)
            end
          end,
        },
      },
    }
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 10,
        },
      },
    }

    opts.extensions = {
      file_browser = {
        -- theme = "flex",
        wrap_results = true,
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "top",
          preview_cutoff = 30, -- the cutoff to switch layout direction
          flex = {
            flip_columns = 95, -- use horizontal layout if columns >= 100
          },
          horizontal = {
            preview_width = 0.55,
          },
          vertical = {
            preview_height = 0.4,
            mirror = true,
          },
        },
        sorting_strategy = "ascending",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          -- your custom insert mode mappings
          ["n"] = {
            -- your custom normal mode mappings
            ["N"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,
            ["/"] = function()
              vim.cmd("startinsert")
            end,
          },
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
}
