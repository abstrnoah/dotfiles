{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "default";
        packages = [ pkgs.cowsay ];
        foo = "bar";
      };
    };
}
