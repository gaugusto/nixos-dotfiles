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

    shellAliases = {
      btw = "echo I use Niri btw";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#niri-btw";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos-dotfiles#niri-btw";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ]; # Adicione os plugins que desejar
    };
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target"; 

    timeouts = [
      # 1. Bloqueia a tela após 5 minutos (300 segundos)
      {
        timeout = 300;
        command = "${pkgs.dms-shell}/bin/dms ipc call lockScreen lock";
      }
      # 2. Desliga os monitores via Niri após 10 minutos (600 segundos)
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        # Opcional: niri costuma religar ao detectar atividade, mas você pode reforçar:
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];

    events = [
      # Bloqueia antes de suspender o sistema
      {
        event = "before-sleep";
        command = "${pkgs.dms-shell}/bin/dms ipc call lockScreen lock";
      }
      # Responde a eventos de lock do sistema
      {
        event = "lock";
        command = "${pkgs.dms-shell}/bin/dms ipc call lockScreen lock";
      }
    ];
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
