{
  brumal.nixpkgs.overlays = [
    (final: prev: {
      dmenu = final.rofi.override { symlink-dmenu = true; };
    })
  ];

  flake.nixosModules.gui =
    {
      pkgs,
      ...
    }:
    {
      brumal.profile.packages = [ pkgs.rofi ];
      brumal.rofi.config = {
        configuration = {
          modi = ''"window,run,combi,filebrowser"'';
          matching = ''"fuzzy"'';
          sorting-method = ''"fzf"'';
          # Unbind conflicts.
          kb-remove-to-eol = ''""'';
          kb-row-tab = ''""'';
          # Custom binds.
          # Difference between row and element??
          kb-row-up = ''"Up"'';
          kb-row-down = ''"Down"'';
          kb-element-prev = ''"Control+p"'';
          kb-element-next = ''"Control+n"'';
          kb-row-select = ''"Tab"'';
          kb-accept-entry = ''"Return,Control+j"'';
          kb-accept-custom = ''"Control+Return"'';
          location = "1";
        };
        window.width = "33%";
      };
    };
}
