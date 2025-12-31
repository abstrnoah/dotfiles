{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      # Patch until https://github.com/NixOS/nixpkgs/pull/472183#issuecomment-3700677971 gets backported
      config.systemd.package =
        if pkgs.systemd.version == "258.2" then
          pkgs.systemd.overrideAttrs (
            finalAttrs: _: {
              version = "258.3";
              src = pkgs.fetchFromGitHub {
                owner = "systemd";
                repo = "systemd";
                rev = "v${finalAttrs.version}";
                hash = "sha256-wpg/0z7xrB8ysPaa/zNp1mz+yYRCGyXz0ODZcKapovM=";
              };
            }
          )
        else
          abort "remove systemd package override";
    };
}
