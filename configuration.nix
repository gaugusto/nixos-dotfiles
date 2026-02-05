{ config, pkgs, ... }: {
  imports =
    [ 
    /etc/nixos/hardware-configuration.nix

    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

# Use latest kernel.
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
# "console=tty1"
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  boot.initrd.luks.devices."luks-c5705b6e-2b54-4b7f-b312-715241659820".device = "/dev/disk/by-uuid/c5705b6e-2b54-4b7f-b312-715241659820";
  networking.hostName = "niri-btw"; # Define your hostname.

    networking.networkmanager.enable = true; 
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

# Set your time zone.
  time.timeZone = "America/Sao_Paulo";

# Select internationalisation properties.
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

# Enable the NIRI
  programs.niri.enable = true;
  systemd.user.targets.niri-session.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};
  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.udev.packages = [ 
    pkgs.swayosd
  ];
  programs.dconf.enable = true;

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
    };

# Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
      enableVPN = true;                  # VPN management widget
      enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
      enableAudioWavelength = true;      # Audio visualizer (cava)
      enableCalendarEvents = true;       # Calendar integration (khal)
      enableClipboardPaste = true;       # Pasting items from the clipboard (wtype)
  };


# Configure console keymap
  console.keyMap = "br-abnt2";

# Enable CUPS to print documents.
  services.printing.enable = true;

# Enable sound with pipewire.
# services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  programs.zsh.enable = true;
  services.dbus.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaugusto = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Guilherme Augusto de Macedo";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    packages = with pkgs; [
#  thunderbird
    ];
  };

# Install chromium.
  programs.chromium.enable = true;

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim 
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
