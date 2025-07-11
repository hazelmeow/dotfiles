{ pkgs, ... }:

{
  # time.timeZone = "America/Los_Angeles";
  time.timeZone = "America/New_York";

  # tools
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # nix garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
}

