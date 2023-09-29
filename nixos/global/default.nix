# This file (and the global directory) holds config that i use on all hosts
{ pkgs
, inputs
, outputs
, ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.hyprland.nixosModules.default
      inputs.disko.nixosModules.disko

      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./opengl.nix
      ./pam.nix
      #./persistance.nix
      ./sops.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  networking.firewall.enable = true;
  services.printing.enable = true;
  services.dbus.enable = true;
  services.geoclue2.enable = true;

  networking.networkmanager.enable = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
