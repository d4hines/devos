# Config for bare-metal NixOS installation

{ config, lib, pkgs, modulesPath, suites, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      (modulesPath + "/installer/scan/not-detected.nix")
    ] ++ suites.base;

  ###### Hardware Configuration #########
  # Generated with `nixos-generate-config`
  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/6beba1cb-9a62-41df-a924-aca556c06450";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/41BB-3572";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  ##### End Hardware Configuration ######

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.enp39s0.useDHCP = true;
  networking.interfaces.wlp41s0.useDHCP = true;

  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "caps:swapescape";
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Include system packages to help debug
  # if something goes wrong
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
