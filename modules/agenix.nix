{
  moduleWithSystem,
  inputs,
  ...
}:
{
  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    { pkgs, ... }:
    {
      imports = [ inputs.agenix.nixosModules.default ];
      config = {
        nixpkgs.overlays = [
          (final: prev: {
            agenix = inputs'.agenix.packages.default;
          })
        ];
        environment.systemPackages = [
          pkgs.agenix
        ];
        age.secrets.networkmanager = {
          file = ../secrets/networkmanager.age;
          owner = "root";
          group = "root";
        };
      };
    }
  );
}
