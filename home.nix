{ config, pkgs, inputs, lib, ...}: 
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  home.username = "gaugusto";
  home.homeDirectory = "/home/gaugusto";
  home.stateVersion = "25.11";

  services.polkit-gnome.enable = true;

  programs.dank-material-shell = {
    enable = true;
    # enableSystemMonitoring = true;
    # dgop.package = inputs.dgop.packages.${pkgs.system}.default;
  };

# programs.bash = {
#   enable = true;
#
#   shellAliases = {
#     btw = "echo I use Niri btw";
#     rebuild-s = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#niri-btw";
#     rebuild-b = "sudo nixos-rebuild boot --flake ~/nixos-dotfiles#niri-btw";
#   };
# };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      btw = "echo I use Niri btw";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#niri-btw";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos-dotfiles#niri-btw";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
        "sudo" 
        "docker" 
        "command-not-found" 
      ];
      theme = "robbyrussell"; 
    };
  };

  programs.alacritty.enable = true;

  home.file.".config/niri".source = ./configs/niri;
  home.file.".config/alacritty".source = ./configs/alacritty;
  home.file.".zshrc".source = ./configs/zshrc;
  home.file.".gitconfig".source = ./configs/gitconfig;

  home.packages = with pkgs; [
    lazygit
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true; # Ative se usar X11 (i3, bspwm, etc.)
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # Importante: Para que as configurações GTK do pointerCursor funcionem, 
  # o módulo GTK deve estar habilitado
  gtk.enable = true;

}
