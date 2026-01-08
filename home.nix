{ config, pkgs, inputs, ...}: 
{
  imports = [
    # inputs.walker.homeManagerModules.default
  ];

  wayland.windowManager.hyprland.systemd.enable = false;

  home.username = "gaugusto";
  home.homeDirectory = "/home/gaugusto";
  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;

    shellAliases = {
      btw = "echo I use Hyprland btw";
      rebuild-s = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      rebuild-b = "sudo nixos-rebuild boot --flake ~/nixos-dotfiles#hyprland-btw";
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
        name  = "John Doe";
        email = "johndoe@example.com";
    };
  };
 
  # programs.walker = {
  #   enable = true;
  #   config = {
  #     search.placeholder = "O que vamos fazer hoje?";
  #     ui.theme = "dark";
  #   };
  # };

  home.file.".config/hypr".source = ./configs/hypr;
  home.file.".config/waybar".source = ./configs/waybar;
  home.file.".config/kitty".source = ./configs/kitty;
  home.file.".local/share/rofi/themes".source = ./configs/rofi;
  home.file.".config/swaync".source = ./configs/swaync;
  home.file.".local/bin".source = ./configs/scripts;

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
   
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Adwaita";
      size = 11;
    };
  };
 
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
