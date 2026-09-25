{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/niri.nix
    ../common/optional/filemanager.nix
    ../common/optional/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "boldan";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
