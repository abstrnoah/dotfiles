# TODO Multi-user wm setup??
{
  flake.modules.nixos.wm =
    {
      config,
      library,
      utilities,
      ...
    }:
    let

      inherit (library)
        mkOption
        types
        concatStringsSep
        mapAttrsToList
        mapAttrs
        mkMerge
        mkIf
        mkDefault
        ;

      inherit (utilities)
        writeTextFile
        ;

    in
    {

      config = mkIf (config.brumal.distro == "nixos") {
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true; # TODO
      };

    };
}
