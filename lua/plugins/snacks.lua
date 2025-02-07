return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      local logo = [[
                                  ,'\
    _.----.        ____         ,'  _\   ___    ___     ____
_,-'       `.     |    |  /`.   \,-'    |   \  /   |   |    \  |`.
\      __    \    '-.  | /   `.  ___    |    \/    |   '-.   \ |  |
 \.    \ \   |  __  |  |/    ,','_  `.  |          | __  |    \|  |
   \    \/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  |
    \     ,-'/  /   \    ,'   | \/ / ,`.|         /  /   \  |     |
     \    \ |   \_/  |   `-.  \    `'  /|  |    ||   \_/  | |\    |
      \    \ \      /       `-.`.___,-' |  |\  /| \      /  | |   |
       \    \ `.__,'|  |`-._    `|      |__| \/ |  `.__,'|  | |   |
        \_.-'       |__|    `-._ |              '-.|     '-.| |   |
                                `'                            '-._|
    ]]
      local cwd = vim.loop.cwd()
      local opts = {
        animate = {
          duration = 20,
          easing = "linear",
          fps = 60,
        },
        dashboard = {
          preset = {
            header = logo,
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = ":lua Snacks.dashboard.pick('files')",
              },
              {
                icon = " ",
                key = "n",
                desc = "New File",
                action = ":ene | startinsert",
              },
              {
                icon = " ",
                key = "g",
                desc = "Find Text",
                action = ":lua Snacks.dashboard.pick('live_grep')",
              },
              {
                icon = " ",
                key = "r",
                desc = "Recent Files",
                action = ":lua Snacks.dashboard.pick('oldfiles')",
              },
              {
                icon = " ",
                key = "R",
                desc = "Recent Files(CWD)",
                action = ":lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})",
              },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              {
                icon = " ",
                key = "s",
                desc = "Restore Session",
                section = "session",
              },
              {
                icon = "󰒲 ",
                key = "L",
                desc = "Lazy",
                action = ":Lazy",
                enabled = package.loaded.lazy ~= nil,
              },
              {
                icon = " ",
                key = "q",
                desc = "Quit",
                action = ":qa",
              },
            },
            footer = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return {
                "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
              }
            end,
          },
          sections = {
            {
              section = "header",
            },
            {
              section = "keys",
              gap = 1,
              padding = 1,
            },
            {
              section = "startup",
            },
            {
              section = "terminal",
              cmd = "pokemon-colorscripts -n metagross -s --no-title; sleep .0",
              random = 10,
              pane = 2,
              indent = 4,
              height = 12,
            },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              pane = 2,
              indent = 2,
              padding = { 2, 2 },
            },
            {
              title = "MRU",
              padding = 1,
              pane = 2,
            },
          },
        },
        lazygit = {
          configure = true,
          config = {
            os = {
              editPreset = "nvim-remote",
            },
            gui = {
              -- set to an empty string "" to disable icons
              nerdFontsVersion = "3",
            },
          },
          theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
          -- Theme for lazygit
          theme = {
            [241] = {
              fg = "Special",
            },
            activeBorderColor = {
              fg = "MatchParen",
              bold = true,
            },
            cherryPickedCommitBgColor = {
              fg = "Identifier",
            },
            cherryPickedCommitFgColor = {
              fg = "Function",
            },
            defaultFgColor = {
              fg = "Normal",
            },
            inactiveBorderColor = {
              fg = "FloatBorder",
            },
            optionsTextColor = {
              fg = "Function",
            },
            searchingActiveBorderColor = {
              fg = "MatchParen",
              bold = true,
            },
            selectedLineBgColor = {
              bg = "Visual",
            }, -- set to `default` to have no background colour
            unstagedChangesColor = {
              fg = "DiagnosticError",
            },
          },
          win = {
            style = "lazygit",
          },
        },
        picker = {
          files = {
            actions = {
              parent = {
                action = function(picker, selected)
                  cwd = vim.loop.fs_realpath(cwd .. "/..")
                  picker:set_cwd(cwd)
                  picker:find()
                end,
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = "close",
              ["<C-c>"] = {
                "close",
                mode = "i",
              },
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<CR>"] = {
                "confirm",
                mode = { "n", "i" },
              },
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["/"] = "toggle_focus",
              ["q"] = "close",
              ["?"] = "toggle_help",
              ["<a-d>"] = {
                "inspect",
                mode = { "n", "i" },
              },
              ["<c-a>"] = {
                "select_all",
                mode = { "n", "i" },
              },
              ["<a-m>"] = {
                "toggle_maximize",
                mode = { "i", "n" },
              },
              ["<a-p>"] = {
                "toggle_preview",
                mode = { "i", "n" },
              },
              ["<a-w>"] = {
                "cycle_win",
                mode = { "i", "n" },
              },
              ["<C-w>"] = {
                "<c-s-w>",
                mode = { "i" },
                expr = true,
                desc = "delete word",
              },
              ["<C-Up>"] = {
                "history_back",
                mode = { "i", "n" },
              },
              ["<C-Down>"] = {
                "history_forward",
                mode = { "i", "n" },
              },
              ["<Tab>"] = {
                "select_and_next",
                mode = { "i", "n" },
              },
              ["<S-Tab>"] = {
                "select_and_prev",
                mode = { "i", "n" },
              },
              ["<Down>"] = {
                "list_down",
                mode = { "i", "n" },
              },
              ["<Up>"] = {
                "list_up",
                mode = { "i", "n" },
              },
              ["<c-j>"] = {
                "list_down",
                mode = { "i", "n" },
              },
              ["<c-k>"] = {
                "list_up",
                mode = { "i", "n" },
              },
              ["<c-n>"] = {
                "list_down",
                mode = { "i", "n" },
              },
              ["<c-p>"] = {
                "list_up",
                mode = { "i", "n" },
              },
              ["<c-l>"] = {
                "preview_scroll_left",
                mode = { "i", "n" },
              },
              ["<c-h>"] = {
                "preview_scroll_right",
                mode = { "i", "n" },
              },
              ["<c-b>"] = {
                "preview_scroll_up",
                mode = { "i", "n" },
              },
              ["<c-d>"] = {
                "list_scroll_down",
                mode = { "i", "n" },
              },
              ["<c-f>"] = {
                "preview_scroll_down",
                mode = { "i", "n" },
              },
              ["<c-g>"] = {
                "toggle_live",
                mode = { "i", "n" },
              },
              ["<c-u>"] = {
                "list_scroll_up",
                mode = { "i", "n" },
              },
              ["<ScrollWheelDown>"] = {
                "list_scroll_wheel_down",
                mode = { "i", "n" },
              },
              ["<ScrollWheelUp>"] = {
                "list_scroll_wheel_up",
                mode = { "i", "n" },
              },
              ["<c-v>"] = {
                "edit_vsplit",
                mode = { "i", "n" },
              },
              ["<c-s>"] = {
                "edit_split",
                mode = { "i", "n" },
              },
              ["<c-q>"] = {
                "qflist",
                mode = { "i", "n" },
              },
              ["<a-i>"] = {
                "toggle_ignored",
                mode = { "i", "n" },
              },
              ["<a-h>"] = {
                "toggle_hidden",
                mode = { "i", "n" },
              },
              ["<a-f>"] = {
                "toggle_follow",
                mode = { "i", "n" },
              },
            },
            b = {
              minipairs_disable = true,
            },
          },
        },
      }
      return opts
    end,
    keys = {
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.dashboard.pick("files")
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        ";ff",
        function()
          Snacks.dashboard.pick("files")
        end,
        desc = "Find Files (Root Dir)",
      },
      { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      -- { "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- { "<leader>fR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      {
        "<leader>fR",
        function()
          Snacks.picker.recent({ cwd = vim.uv.cwd() })
        end,
        desc = "Recent (cwd)",
      },
      -- git
      {
        "<leader>gc",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      -- Grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      -- { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>qp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
  },
}
