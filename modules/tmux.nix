# TODO
{
}
# top@{ config, ... }:
# {
#   flake.nixosModules.base =
#     { config, library, ... }:
#     let
#       inherit  (library) mkOption mkEnableOption mkPackageOption types mkIf;
#       cfg = config.brumal.programs.tmux;
#       opts =
#         {
#           enable = mkEnableOption "tmux";
#           package = mkPackageOption "tmux";
#           rc = mkOption { type = types.lines; };
#         };
#     in
#     {
#       options.brumal.programs.tmux = opts;
#       config = mkIf cfg.enable
#         {
#           environment.systemPackages = [
#         };
#     };
# }
