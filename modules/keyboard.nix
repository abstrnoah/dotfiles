{
  flake.modules.nixos.machine = {
    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;
  };
}
