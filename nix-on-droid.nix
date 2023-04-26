{ pkgs, ... }:

{

  # Just what is necessary to bootstrap nixphile.
  environment.packages = with pkgs; [
    coreutils
    curl
    openssh
    git
    netcat-openbsd
    nettools
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "22.11";

  user.shell = "${pkgs.zsh}/bin/zsh";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

}
