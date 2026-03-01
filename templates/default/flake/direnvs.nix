{ inputs, ... }:
{
  imports = [ inputs.dotfiles.flakeModules.direnvs ];
  perSystem =
    { pkgs, ... }:
    {
      direnvs.default = {
        variables.foo = "bar";
        packages = [ pkgs.cowsay ];
      };
    };
}
