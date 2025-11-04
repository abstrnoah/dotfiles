{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    {
      brumal.programs.nixpkgs.allowUnfree = [
        "rxvt-unicode"
        "urxvt-theme-switch"
      ];
      environment.systemPackages = [ pkgs.rxvt-unicode ];
      brumal.programs.xresources = {
        "URxvt.saveline" = "2048";
        "URxvt.scrollBar" = "false";
        "URxvt.scrollBar_right" = "false";
        "URxvt.urgentOnBell" = "true";
        "URxvt.depth" = "24";
        "URxvt.underlineURLs" = "true";
      };
    };
}
