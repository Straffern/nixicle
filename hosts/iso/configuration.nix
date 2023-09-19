{ pkgs
, lib
, ...
}: {
  imports = [
    ../../nixos/global
    ../../nixos/optional/attic.nix
    ../../nixos/optional/thunderbolt.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  home-manager.users.nixos = import ./home.nix;
  users.extraUsers.root.password = "nixos";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AaAeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee username@host"
  ];

  services.hardware.bolt.enable = true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  environment.systemPackages = with pkgs; [
    git
    gum
    (
      writeShellScriptBin "nix_installer" ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        if [ ! -d "$HOME/dotfiles/.git" ]; then
        	git clone https://gitlab.com/hmajid2301/dotfiles.git "$HOME/dotfiles"
        fi

        TARGET_HOST=$(ls -1 ~/dotfiles/hosts/*/configuration.nix | cut -d'/' -f6 | grep -v iso | gum choose)

        if [ ! -e "$HOME/dotfiles/hosts/$TARGET_HOST/disks.nix" ]; then
        	echo "ERROR! $(basename "$0") could not find the required $HOME/dotfiles/hosts/$TARGET_HOST/disks.nix"
        	exit 1
        fi

        gum confirm \
        "🔥 🔥 🔥 WARNING!!!! This will ERASE ALL DATA on the disk $TARGET_HOST. \n\n Are you sure you want to continue?" \
        --default=false

        sudo true

        echo "Partitioning Disks"
        # TODO: partition inside nixos install
        sudo nix run github:nix-community/disko \
        --extra-experimental-features "nix-command flakes" \
        --no-write-lock-file \
        -- \
        --mode zap_create_mount \
        "$HOME/dotfiles/hosts/$TARGET_HOST/disks.nix"

        echo "Creating blank volume"
        sudo btrfs subvolume create /mnt/root
        sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

        echo "Set up attic binary cache"
        ATTIC_TOKEN=$(gum input --placeholder "Enter your Attic token here" --password)
        attic login prod https://majiy00-nix-binary-cache.fly.dev $ATTIC_TOKEN
        attic use prod:prod || true

        sudo nixos-install --flake "$HOME/dotfiles#$TARGET_HOST"
      ''
    )
  ];
}
