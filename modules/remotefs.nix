{
  flake.nixosModules.base =
    { pkgs, config, ... }:
    let
      secrets = config.age.secrets;
    in
    {
      environment.systemPackages = [
        pkgs.restic
        pkgs.rclone
      ];
      # TODO The token keeps expiring like every few hours...
      # brumal.files.xdgConfig."rclone/rclone.conf".source = secrets.rclone.path;
    };
}
