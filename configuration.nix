{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "transparent_hugepage=always"
      "preempt=full"
    ];
  };
 

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";


  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-mauve";
    wayland.enable = true;
  };

  services.power-profiles-daemon.enable = true;
  systemd.user.units.swaync.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaugusto = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video"];
    packages = with pkgs; [
      tree
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  programs.firefox.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; 
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim
    bash
    wget
    git
    kitty
    waybar
    hyprpaper
    hypridle
    hyprlock
    nautilus
    rofi
    brightnessctl
    nitch
    power-profiles-daemon
    pavucontrol
    gcc
    swaynotificationcenter
    libnotify
    wlogout
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
    gnome-themes-extra
    adwaita-icon-theme
    nwg-look
    htop
    btop
    bluez
    lazygit
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    liberation_ttf
    cantarell-fonts
    adwaita-fonts
  ];

  # nix management automations
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}

