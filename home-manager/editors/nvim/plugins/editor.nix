{ pkgs, ... }: {
  imports = [
    ./editor/notes.nix
    ./editor/telescope.nix
    ./editor/trouble.nix
  ];

  programs.nixvim = {
    clipboard.providers.wl-copy.enable = true;

    maps = {
      normalVisualOp = {
        "<leader>gls" = {
          action =
            # lua
            ''
              function()
                      require("flash").jump()
              end
            '';
          desc = "Run flash";
        };
        "<leader>glt" = {
          action =
            # lua
            ''
              function()
                      require("flash").treesitter()
              end
            '';
          desc = "Run flash treesitter";
        };
      };
      normal = {
        "<leader>uu" = {
          action = "<cmd>Telescope undo<cr>";
          desc = "Show undo tree";
        };
        "<leader>nb" = {
          action = "<cmd>Navbuddy<cr>";
          desc = "Show navbuddy";
        };
        "<leader>sr" = {
          action =
            # lua
            ''
              function()
              	require("spectre").open()
              end
            '';
          desc = "Replace in files";
        };
      };
    };

    plugins = {
      # auto-save = {
      #   enable = true;
      #   debounceDelay = 5000;
      #   extraOptions = {
      #     trigger_events = ["TextChanged"];
      #   };
      # };

      illuminate = {
        enable = true;
        delay = 200;
        underCursor = true;
        largeFileOverrides = {
          largeFileCutoff = 2000;
        };
      };

      oil = {
        enable = true;
        deleteToTrash = true;
      };

      nvim-lightbulb = {
        enable = true;
      };

      harpoon = {
        enable = true;
        tmuxAutocloseWindows = true;
        keymaps = {
          addFile = "<leader>ha";
          toggleQuickMenu = "<leader>ht";
          navNext = "<leader>hn";
          navPrev = "<leader>hp";
        };
      };

      nvim-colorizer = {
        enable = true;
      };

      todo-comments = {
        enable = true;
      };

      indent-blankline = {
        enable = true;
        filetypeExclude = [
          "help"
          "terminal"
          "lazy"
          "lspinfo"
          "TelescopePrompt"
          "TelescopeResults"
          "Alpha"
          ""
        ];
        showTrailingBlanklineIndent = false;
        showFirstIndentLevel = false;
        spaceCharBlankline = " ";
        showEndOfLine = true;
      };

      which-key = {
        enable = true;
      };
    };

    extraPlugins = with pkgs; [
      vimPlugins.better-escape-nvim
      vimPlugins.telescope-undo-nvim
      vimPlugins.nvim-spectre
      vimPlugins.flash-nvim
      vimPlugins.nvim-navbuddy
      vimPlugins.sqlite-lua
    ];

    extraConfigLua =
      # lua
      ''
        -- undo-telescope
        require("telescope").load_extension("undo")
        require("which-key").register({
        mode = {"n", "v"},
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>h"] = { name = "+harpoon" },
        })

        require("better_escape").setup()
        require("flash").setup()
        require("nvim-navbuddy").setup({lsp = { auto_attach = true }})
      '';
  };
}
