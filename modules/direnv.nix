{ inputs, ... }:
{
  flake.nixosModules.base = {
    imports = [
      inputs.direnv-instant.nixosModules.direnv-instant
    ];
    programs.direnv-instant.enable = true;
    programs.direnv.silent = false;
    programs.bash.interactiveShellInit = ''
      alias nix='BR_SHELL_NESTING="$BR_SHELL_NESTING " nix'
      alias nix-shell='BR_SHELL_NESTING="$BR_SHELL_NESTING " nix-shell'
    '';
  };
}
