{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    {
      brumal.programs.nixpkgs.allowUnfree = [ "rxvt-unicode" ];
      environment.systemPackages = [ pkgs.rxvt-unicode ];
      brumal.programs.xresources = {
        # "URxvt.font" = "pango:mononoki:stype=Regular:size=8";
        "URxvt.saveline" = "2048";
        "URxvt.scrollBar" = "false";
        "URxvt.scrollBar_right" = "false";
        "URxvt.urgentOnBell" = "true";
        "URxvt.depth" = "24";
      };
    };
}
