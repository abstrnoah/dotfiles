{
  flake.nixosModules.brumal =
    {
      pkgs,
      config,
      library,
      utilities,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        mapAttrsToList
        nameValuePair
        mapAttrs'
        ;
      cfg = config.brumal.tmux;
      env = config.brumal.env;
      opts = {
        conf = mkOption { type = types.lines; };
        tmuxinator = mkOption { type = types.attrsOf types.lines; };
      };
      makeTmuxinatorProfile =
        profile: text:
        nameValuePair "${profile}.tmuxinator" {
          inherit text;
          target = ".tmuxinator/${profile}.yml";
        };
      # TODO Nixify yaml or do away with tmuxinator entirely
      tmuxinatorProfiles = mapAttrs' makeTmuxinatorProfile cfg.tmuxinator;
    in
    {
      options.brumal.tmux = opts;
      config = {
        environment.systemPackages = [ pkgs.tmux ];
        brumal.profile.packages = [
          pkgs.tmuxinator
        ];
        brumal.files.home = {
          ".tmux.conf".text = cfg.conf;
        }
        // tmuxinatorProfiles;
      };
    };
}
