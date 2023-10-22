{ pkgs, lib, ... }: {
  imports = [
    ./attic.nix
    ./atuin.nix
    ./bat.nix
    ./bottom.nix
    ./calcure.nix
    ./direnv.nix
    ./eza.nix
    ./foliate.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./k8s.nix
    ./kafka.nix
    ./gaming.nix
    ./kdeconnect.nix
    ./file_managers/lf.nix
    ./file_managers/yazi.nix
    ./photos.nix
    ./starship.nix
    ./zoxide.nix
  ];

  xdg.configFile."." = {
    source = ./config;
    recursive = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # programs.obs-studio = {
  #   enable = true;
  # };

  home.packages = with pkgs; [
    #tmp
    cargo
    rustc
    #go
    tudu

    nix-init
    nix-update
    nix-your-shell

    # sourcegraph
    src-cli

    (lib.hiPrio parallel)
    moreutils
    nvtop-amd
    htop
    ctpv
    unzip
    pavucontrol
    gnupg
    ferdium

    # other
    brotab
    betterdiscord-installer
    discord
    showmethekey
    fontforge
    thunderbird-unwrapped

    # modern "unix" tools
    broot
    choose
    curlie
    chafa
    dogdns
    duf
    delta
    du-dust
    dysk
    entr
    erdtree
    fd
    gdu
    gping
    hyperfine
    hexyl
    lazydocker
    ouch
    silver-searcher
    thefuck
    procs
    psensor
    shell-genie
    tokei
    trash-cli
    ripgrep
    sd
    xcp
    yq
    zk

    # cheat sheets
    cheat
    cht-sh
    navi
    tealdeer

    # for fun
    asciinema
    cava
    cmatrix
    charasay
    fortune
    lolcat
    neofetch
    sl
  ];
}
