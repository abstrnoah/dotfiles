{ nixpkgs }:

rec {
  test = { envs = [ ./store/root ]; };
}
