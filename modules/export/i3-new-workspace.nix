{ inputs, library, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      utilities,
      ...
    }:
    let
      inherit (library) readFile;
      inherit (utilities) writeShellApplication;
    in
    {
      packages.i3-new-workspace = writeShellApplication {
        name = "i3-new-workspace";
        text = readFile "${inputs.i3-new-workspace}/i3-new-workspace";
        # TODO FIXME For some reason I cannot fathom, I am unable to override i3 = i3-rounded, so leaving this as an implicit dependency for now.
        # runtimeInputs = [ pkgs.i3 ];
      };
      overlayAttrs = { inherit (self'.packages) i3-new-workspace; };
    };
}
