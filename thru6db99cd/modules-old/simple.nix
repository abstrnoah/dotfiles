{ lib, ... }:
let
  # TODO consider refactoring
  # Dotfiles that are just plain text files stored in ./src
  # and bundled with packages of the same name.
  withConfig =
    lib.genAttrs
      [
        "curl"
        "git"
        "tmux"
        "tmuxinator"
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

in
{
  flake.modules.brumal = withConfig;
}
