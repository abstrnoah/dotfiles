{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    {
      brumal.nixpkgs.allowUnfree = [
        "rxvt-unicode"
        "urxvt-theme-switch"
      ];
      environment.systemPackages = [ pkgs.rxvt-unicode ];
      brumal.xresources = {
        "URxvt.saveline" = "2048";
        "URxvt.scrollBar" = "false";
        "URxvt.scrollBar_right" = "false";
        "URxvt.urgentOnBell" = "true";
        "URxvt.depth" = "24";
        "URxvt.underlineURLs" = "true";
      };
    };
}
