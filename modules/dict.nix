{
  flake.nixosModules.base =
    { pkgs, library, ... }:
    let
      inherit (library) getExe;
    in
    {
      brumal.profile.packages = [ pkgs.dict ];
      brumal.files.home.".dictrc".text = "server dict.org";
      brumal.files.bin = {
        defn.runtimeInputs = [
          pkgs.dict
          pkgs.bat
        ];
        defn.text = ''
          if test "$#" -eq 1; then
            dict -d wn "$@"
          else
            dict "$@" | bat -p
          fi
        '';
        thes.runtimeInputs = [ pkgs.dict ];
        thes.text = ''dict -d moby-thesaurus "$@"'';
      };
    };
}
