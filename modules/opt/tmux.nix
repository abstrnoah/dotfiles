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
      inherit (library) mkOption types mapAttrsToList;
      inherit (utilities) writeTextFile buildEnv;
      cfg = config.brumal.programs.tmux;
      env = config.brumal.env;
      opts = {
        conf = mkOption { type = types.lines; };
        tmuxinator = mkOption { type = types.attrsOf types.lines; };
      };
      tmuxRcP = writeTextFile {
        name = "tmux-conf";
        text = cfg.conf;
        destination = "${env.HOME}/.tmux.conf";
      };
      makeTmuxinatorProfile =
        name: value:
        writeTextFile {
          name = "${name}.tmuxinator";
          text = value;
          destination = "${env.HOME}/.tmuxinator/${name}.yml";
        };
      # TODO Nixify yaml or do away with tmuxinator entirely
      tmuxinatorRcP = buildEnv {
        name = "tmuxinators";
        paths = mapAttrsToList makeTmuxinatorProfile cfg.tmuxinator;
      };
    in
    {
      options.brumal.programs.tmux = opts;
      config = {
        environment.systemPackages = [ pkgs.tmux ];
        brumal.profile.packages = [
          pkgs.tmuxinator
          tmuxinatorRcP
          tmuxRcP
        ];
      };
    };
}
