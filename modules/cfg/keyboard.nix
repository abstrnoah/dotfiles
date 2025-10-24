{
  flake.nixosModules.base = {
    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;
  };
}
