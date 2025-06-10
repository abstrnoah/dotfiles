{ lib, ... }:
let
  # Dotfiles that are just plain text files stored in ./src
  # and bundled with packages of the same name.
  withConfig =
    lib.genAttrs
      [
        "curl"
        "git"
        "tmux"
        "visidata"
        "dict"
        "ttdl"
        "udiskie"
        "dunst"
        "zathura"
        "zsh"
        "pulseaudio"
      ]
      (
        name:
        { library, packages, ... }:
        {
          legacyDotfiles.${name} = library.storeLegacyDotfiles name;
          userPackages.${name} = packages.${name};
        }
      );

  # # Dotfiles that have to package.
  # justSrc =
  #   lib.genAttrs
  #     [
  #       "bluetooth" # TODO super unpure
  #     ]
  #     (
  #       name:
  #       { library, packages, ... }:
  #       {
  #         legacyDotfiles.${name} = library.storeLegacyDotfiles name;
  #       }
  #     );

in
{
  flake.modules.brumal = withConfig # // justSrc
  ;
}
