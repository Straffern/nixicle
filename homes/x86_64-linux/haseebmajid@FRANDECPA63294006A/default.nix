{
  pkgs,
  lib,
  ...
}: let
  screensharing = pkgs.writeScriptBin "screensharing" ''
    #!/usr/bin/env bash
    sleep 1
    killall -e xdg-desktop-portal-hyprland
    killall -e xdg-desktop-portal-wlr
    killall xdg-desktop-portal
    /usr/libexec/xdg-desktop-portal-hyprland &
    sleep 2
    /usr/libexec/xdg-desktop-portal &
  '';
in {
  roles = {
    desktop.enable = true;
  };

  xdg.desktopEntries.firefox = {
    name = "firefox";
    genericName = "Browser";
    exec = "nixGLIntel firefox"; # this is the main fix and the rest is to conform with original
    icon = "firefox";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings = {
      TryExec = "firefox";
    };
  };

  cli.terminals.alacritty.enable = true;

  desktops = {
    hyprland = {
      enable = true;
      execOnceExtras = [
        "warp-taskbar"
        "blueman-applet"
        "${screensharing}/bin/screensharing"
        "nm-applet"
      ];
    };

    gnome.enable = true;
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$PATH:/home/haseebmajid/.nix-profile/bin"
  '';

  cli.programs = {
    git = {
      allowedSigners = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOEtfQ0znAH8QyB4Z5FzRPa9iKkBhuriEpqyfoEkiv+ haseeb.majid@imaginecurve.com";
      email = "haseeb.majid@imaginecurve.com";
      urlRewrites = {
        "git@gitlab.com:imaginecurve/" = "https://gitlab.com/imaginecurve/";
        "git@gitlab.com:" = "https://gitlab.com";
      };
    };
    ssh = {
      extraHosts = {
        "gitlab-personal" = {
          hostname = "gitlab.com";
          identityFile = "~/.ssh/id_ed25519_personal";
        };
        "gitlab.com" = {
          hostname = "gitlab.com";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };

  nixicle.user = {
    enable = true;
    name = "haseebmajid";
  };

  home.stateVersion = "23.11";
}
