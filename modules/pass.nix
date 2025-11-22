{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      ...
    }:
    let
      k = config.brumal.i3wm.keys;
    in
    {
      brumal.profile.packages = [
        pkgs.pass
      ];
      brumal.i3wm.body.bindsym."${k.alt}+p" = "exec ${pkgs.pass}/bin/passmenu";
      nixpkgs.overlays = [
        (final: prev: {
          pass = prev.pass.overrideAttrs (
            final: prev: { patches = prev.patches ++ [ ../src/pass/set-prompt.patch ]; }
          );
        })
      ];
    };
}
