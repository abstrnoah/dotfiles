# TODO:
# Step 1. Set `projectName` below
# Step 2. Do `nix run --inputs-from . 'opam-nix#dune.latest' -- init project ${projectName} .`
# Step 3. Do `nix-direnv-reload`
# Step 4. Say hello: `dune exec -- ${projectName}`

{ inputs, ... }:
{
  perSystem =
    { pkgs, system, self', ... }:
    let
      inherit (inputs.opam-nix.lib.${system}) buildDuneProject;
      projectName = "TODO: This is the same as you pass to `dune init`";
      query = {
        ocaml-lsp-server = "*";
        ocamlformat = "*";
        utop = "*";
      };
      onScope = buildDuneProject { } projectName ../. query;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          onScope.ocaml-lsp-server
          onScope.ocamlformat
          onScope.utop
        ];
        inputsFrom = [ onScope.${projectName} ];
      };
      packages.${projectName} = onScope.${projectName};
      packages.default = self'.packages.${projectName};
      legacyPackages = onScope;
    };
}
