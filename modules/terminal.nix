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
      brumal.i3wm.body.bindsym.${config.brumal.i3wm.keys.enter} = "exec i3-sensible-terminal";
    };
}
