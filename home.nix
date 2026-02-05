{ config, pkgs, inputs, lib, ...}: 
{
  imports = [
  ];

  home.username = "gaugusto";
  home.homeDirectory = "/home/gaugusto";
  home.stateVersion = "25.11";


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

    # Em vez de initExtraFirst, usamos initContent com mkBefore
    initContent = lib.mkBefore ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    shellAliases = {
      btw = "echo I use Niri btw";
      nrs = "sudo nrs switch --impure --flake ~/nixos-dotfiles#niri-btw";
      nrb = "sudo nrb boot --impure --flake ~/nixos-dotfiles#niri-btw";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ]; # Adicione os plugins que desejar
    };
  };

  programs.alacritty.enable = true;
  services.polkit-gnome.enable = true;

  home.file.".config/niri".source = ./configs/niri;
  home.file.".config/alacritty".source = ./configs/alacritty;
  home.file.".zshrc".source = ./configs/zshrc;
  home.file.".gitconfig".source = ./configs/gitconfig;

  home.packages = with pkgs; [
    lazygit
  ];
}
