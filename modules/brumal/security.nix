{
  flake.nixosModules.brumal =
    {
      config,
      library,
      ownerName,
      ...
    }:
    let
      inherit (library) mkOption types;
    in
    {
      options.brumal.sudoGroup = mkOption {
        type = types.str;
        default = "wheel";
      };
      config.users.users.${ownerName}.extraGroups = [ config.brumal.sudoGroup ];
    };
}
