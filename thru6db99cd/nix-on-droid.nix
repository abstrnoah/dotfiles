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

  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version;

  user.shell = "${pkgs.zsh}/bin/zsh";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

}
