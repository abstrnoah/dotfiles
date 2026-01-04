{
  flake.nixosModules.gui =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.zathura ];
      brumal.files.xdgConfig."zathura/zathurarc".text = ''
        set window-title-home-tilde true
        set window-title-basename true
        set statusbar-home-tilde true
        set statusbar-basename true
        set selection-clipboard "${config.brumal.clipboard.selection}"
      '';
      xdg.mime.defaultApplications = {
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/postscript" = "org.pwmt.zathura.desktop";
        "image/vnd.djvu" = "org.pwmt.zathura.desktop";
      };
    };
}
