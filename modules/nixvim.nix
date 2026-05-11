{inputs, lib, ...}: {
  flake.modules.homeManager.nixvim = {
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixvim.homeModules.nixvim
    ];

    programs.nixvim = {
      enable = true;

      # Clipboard
      opts.clipboard = {
        provider = "unnamedplus";
      };

      # Editor settings
      opts = {
        number = true;
        relativenumber = true;
        cursorline = true;
        showmode = false;
        termguicolors = true;
        background = "dark";
        splitright = true;
        splitbelow = true;
        scrolloff = 8;
        sidescrolloff = 8;
        mouse = "a";
        timeout = true;
        timeoutlen = 300;
        undofile = true;
        undolevels = 10000;
        wrap = false;
        linebreak = true;
        showtabline = 2;
        signcolumn = "yes";
        laststatus = 3;
        pumblend = 10;
        winblend = 10;
      };

      # Global settings
      globals = {
        mapleader = " ";
        maplocalleader = " ";
        loaded_rplugin = 1;
      };

      # Colorscheme - Catppuccin
      colorschemes.catppuccin = {
        enable = true;
        flavor = "mocha";
        integrate = {
          cmp = true;
          treesitter = true;
          which-key = true;
          neorg = true;
          navic = true;
          notify = true;
          mini = true;
        };
      };

      # ── Plugins ──────────────────────────────────────────────────────────────

      plugins = {
        # Web devicons (required by bufferline)
        web-devicons = {
          enable = true;
        };

        # File explorer
        nvim-tree-lua = {
          enable = true;
          openOnSetup = false;
          updateFocusedFile = {
            enable = true;
          };
          view = {
            adaptiveSize = true;
            side = "left";
            width = 35;
            hideRootFolder = true;
          };
        };

        # Buffer line
        bufferline = {
          enable = true;
          settings = {
            diagnostics_indicator = true;
            offsets = [
              {
                filetype = "NvimTree";
                text = "Explorer";
                highlight = "Directory";
                text_align = "center";
              }
            ];
          };
        };

        # Status line
        lualine = {
          enable = true;
          theme = "catppuccin";
          extensions = ["nvim-tree" "telescope"];
        };

        # Fuzzy finder
        telescope-nvim = {
          enable = true;
          extensions = {
            fzf-native = {
              enable = true;
            };
          };
        };

        # Syntax highlighting
        nvim-treesitter = {
          enable = true;
          ensureInstalled = [
            "nix"
            "lua"
            "vim"
            "vimdoc"
            "python"
            "go"
            "rust"
            "yaml"
            "json"
            "markdown"
            "bash"
          ];
          indent = {
            enable = true;
          };
        };

        # Auto pairs
        nvim-autopairs = {
          enable = true;
        };

        # Comments
        nvim-comment = {
          enable = true;
        };

        # Indentation guides
        indent-blankline = {
          enable = true;
          settings = {
            char = "▏";
            showTrailingBlanklineIndent = false;
            useColor = true;
          };
        };

        # Git integration
        gitsigns = {
          enable = true;
        };

        # Which-key
        which-key-nvim = {
          enable = true;
        };

        # LSP
        nvim-lspconfig = {
          enable = true;
        };

        # LSP signatures
        lsp-signature-nvim = {
          enable = true;
        };

        # LSP progress
        lsp-progress-nvim = {
          enable = true;
        };

        # CMP (completion)
        nvim-cmp = {
          enable = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
              {name = "luasnip";}
            ];
          };
        };

        # Snippets
        luasnip = {
          enable = true;
        };

        # Mason (LSP manager)
        mason-nvim = {
          enable = true;
        };

        # Toggle term
        toggleterm-nvim = {
          enable = true;
        };

        # Todo comments
        todo-comments-nvim = {
          enable = true;
        };

        # Notifications
        notify-nvim = {
          enable = true;
        };

        # Diff view
        diffview-nvim = {
          enable = true;
        };

        # Neogit
        neogit = {
          enable = true;
        };

        # Flash nvim
        flash-nvim = {
          enable = true;
        };

        # Conform (formatter)
        conform-nvim = {
          enable = true;
        };

        # Noicer
        noice-nvim = {
          enable = true;
        };
      };

      # ── Keybindings ──────────────────────────────────────────────────────────

      keymaps = [
        # Telescope
        {
          mode = "n";
          key = "<leader>ff";
          action = "<cmd>Telescope find_files<cr>";
          options = {desc = "Find files";};
        }
        {
          mode = "n";
          key = "<leader>fg";
          action = "<cmd>Telescope live_grep<cr>";
          options = {desc = "Live grep";};
        }
        {
          mode = "n";
          key = "<leader>fb";
          action = "<cmd>Telescope buffers<cr>";
          options = {desc = "Find buffers";};
        }
        {
          mode = "n";
          key = "<leader>fh";
          action = "<cmd>Telescope help_tags<cr>";
          options = {desc = "Find help";};
        }
        {
          mode = "n";
          key = "<leader>fr";
          action = "<cmd>Telescope oldfiles<cr>";
          options = {desc = "Recent files";};
        }

        # File explorer
        {
          mode = "n";
          key = "<leader>ft";
          action = "<cmd>NvimTreeToggle<cr>";
          options = {desc = "Toggle file explorer";};
        }

        # Git
        {
          mode = "n";
          key = "<leader>gc";
          action = "<cmd>Neogit<cr>";
          options = {desc = "Git commit";};
        }

        # Todo
        {
          mode = "n";
          key = "<leader>td";
          action = "<cmd>TodoTrouble<cr>";
          options = {desc = "Todo trouble";};
        }
        {
          mode = "n";
          key = "<leader>ts";
          action = "<cmd>TodoTelescope<cr>";
          options = {desc = "Todo search";};
        }

        # Window navigation
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          options = {desc = "Move to left window";};
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          options = {desc = "Move to right window";};
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          options = {desc = "Move to below window";};
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          options = {desc = "Move to above window";};
        }

        # Copy/paste
        {
          mode = ["n" "v"];
          key = "<leader>d";
          action = "\"_d";
          options = {desc = "Delete without yank";};
        }
        {
          mode = ["n" "v"];
          key = "<leader>y";
          action = "\"+y";
          options = {desc = "Yank to clipboard";};
        }
        {
          mode = ["n" "v"];
          key = "<leader>p";
          action = "\"+p";
          options = {desc = "Paste from clipboard";};
        }

        # Save
        {
          mode = "n";
          key = "<leader>w";
          action = "<cmd>w<cr>";
          options = {desc = "Save file";};
        }
        {
          mode = "i";
          key = "<C-s>";
          action = "<cmd>w<cr><Esc>";
          options = {desc = "Save file";};
        }
      ];

      # Extra Lua configuration
      extraConfigLua = ''
        -- Flash nvim setup
        require("flash").setup({
          modes = {
            char = {
              jump_labels = true,
            },
          },
        })
      '';
    };
  };
}