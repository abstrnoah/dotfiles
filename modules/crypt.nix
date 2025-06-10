{
  flake.modules.brumal.crypt =
    { packages, ... }:
    {
      userPackages = {
        # TODO
        # gnupg
        # pass
        # pinentry
        # age
      };
    };
}
