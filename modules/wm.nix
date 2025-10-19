{
  flake.nixosModules.gui.services = {
    xserver.enable = true;
    displayManager.gdm.enable = true;
  };
}
