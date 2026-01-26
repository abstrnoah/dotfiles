{
  moduleWithSystem,
  inputs,
  ...
}:
{
  perSystem =
    { inputs', ... }:
    {
      overlayAttrs = {
        agenix = inputs'.agenix.packages.default;
      };
    };
  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    {
      pkgs,
      ownerName,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.nixosModules.default ];
      config = {
        environment.systemPackages = [
          pkgs.agenix
        ];
        age.secrets.networkmanager = {
          file = ../secrets/networkmanager.age;
          owner = "root";
          group = "root";
        };
        age.secrets.rclone = {
          file = ../secrets/rclone.age;
          owner = ownerName;
          group = config.brumal.sudoGroup;
        };
      };
    }
  );
}
