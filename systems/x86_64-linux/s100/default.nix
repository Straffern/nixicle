{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  roles = {
    server.enable = true;
  };

  # # TODO: move to module
  # networking.firewall.allowedTCPPorts = [
  #   8123
  # ];

  services.nixicle = {
    traefik.enable = true;
    home-assistant.enable = true;
    adguard.enable = true;
  };

  boot = {
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "23.11";
}
