{
  flake.modules.nixos.base =
    { library, config, ... }:
    {
      options.brumal.sudoGroup = library.mkOption {
        type = library.types.enum [
          "wheel"
          "sudo"
        ];
      };
      config = {
        brumal.sudoGroup = library.mkCases config.brumal.distro {
          nixos = "wheel";
          debian = "sudo";
        };
        users.users.${config.brumal.owner}.extraGroups = [ config.brumal.sudoGroup ];
      };
    };
}
