{
  flake.nixosModules.gui = {
    brumal.programs.rofi = {
      config.configuration = {
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
        location = ''2'';
      };
    };
  };
}
