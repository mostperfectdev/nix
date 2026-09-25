{ pkgs, inputs, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/niri.nix
    ../common/optional/filemanager.nix
    ../common/optional/docker.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [
    "synaptics_usb"
  ];
  # boot.blacklistedKernelModules = [ "mt7925e" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  networking.hostName = "barlow"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.powersave = false;

  services.openssh.enable = true;
  programs.mosh.enable = true;

  networking.wireless.iwd = {
    enable = true;
    # settings.DriverQuirks.PowerSaveDisable = "mt7925e";
  };
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.allowedTCPPorts = [
    3000
    44015
  ];

  environment.systemPackages = with pkgs; [ brightnessctl ];

  system.stateVersion = "24.11";
}
