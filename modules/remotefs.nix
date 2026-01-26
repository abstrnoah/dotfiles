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
      brumal.files.xdgConfig."rclone/rclone.conf".source = secrets.rclone.path;
    };
}
