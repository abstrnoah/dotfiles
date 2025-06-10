{
  flake.modules.brumal.tex =
    { packages, ... }:
    {
      userPackages = {
        # TODO Why do I have both lol?
        inherit (packages) texlive tectonic;
      };
    };
}
