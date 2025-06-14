top@{ config, ... }:
{
  flake.machines.coyote =
    {
      lib,
      library,
      packages,
      ...
    }:
    {
      system = "x86_64-linux";
      distro = "debian";
      hostname = "coyote";
      owner.name = "abstrnoah";

      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          cl
          gui
          wm
          pulseaudio
          ;

      };

      legacyDotfiles.nix_env_exports = library.writeTextFile {
        name = "nix_env_exports";
        text = ''
          export ${lib.toShellVar "LOCALE_ARCHIVE" "${packages.glibcLocales}/lib/locale/locale-archive"}
          export QT_XCB_GL_INTEGRATION=none
        '';
        destination = "/lib/nix_env_exports";
      };
    };
}
