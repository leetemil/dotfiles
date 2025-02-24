{ config, pkgs, ... }:

{
  home.username = "emp";
  home.homeDirectory = "/home/emp";

  home.stateVersion = "23.11";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.home-manager.enable = true;

  # services.ssh-agent.enable = true;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };
}
