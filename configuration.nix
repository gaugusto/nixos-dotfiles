{ config, pkgs, ... }: {
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  boot = {
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
         selected_themes = [ "rings" ];
         })
      ];
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "transparent_hugepage=always"
      "preempt=full"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver 
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  networking.hostName = "niri-btw"; # Define your hostname.
  networking.networkmanager.enable = true; 

  time.timeZone = "America/Sao_Paulo";
  console.keyMap = "br-abnt2";

  i18n.defaultLocale = "en_US.UTF-8"; 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  users.users.gaugusto = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Guilherme Augusto de Macedo";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    packages = with pkgs; [
    ];
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;
  services.libinput.enable = true;
  services.dbus.enable = true;

  # services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --remember \
          '';
        user = "greeter";
      };
    };
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.chromium.enable = true;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    htop
    alacritty
    xwayland-satellite
    stow
    nautilus
    chromium
    libnotify
    libinput
    pulseaudio
    brightnessctl
    jq
    wl-clipboard
    gsettings-desktop-schemas
    adwaita-icon-theme
    dconf
    xdg-user-dirs
  ];

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
      cantarell-fonts
      adwaita-fonts
  ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;


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

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

                       }
