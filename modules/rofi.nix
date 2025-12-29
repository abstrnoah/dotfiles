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
          kb-element-prev = ''"Control+k"'';
          kb-element-next = ''"Control+j"'';
          kb-row-select = ''"Tab"'';
          kb-accept-entry = ''"Return"'';
          kb-accept-custom = ''"Control+Return"'';
          location = ''1'';
        };
        window.width = ''25%'';
      };
    };
}
