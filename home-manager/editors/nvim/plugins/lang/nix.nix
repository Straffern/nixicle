{ pkgs
, config
, ...
}: {
  home.packages = with pkgs; [
    nixd
  ];

  programs.nixvim = {
    plugins = {
      nix.enable = true;
      lsp.servers.nixd = {
        enable = true;
      };

      treesitter = {
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          nix
        ];
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      hmts-nvim
      nix-develop-nvim
    ];

    extraConfigVim = ''
      au BufRead,BufNewFile flake.lock setf json

    '';
  };
}
