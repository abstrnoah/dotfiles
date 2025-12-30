{ library, ... }:
let
  inherit (library) attrNames readDir genAttrs;
in
{
  flake.templates = genAttrs (attrNames (readDir ../../templates)) (name: {
    description = "abstrnoah's ${name} template";
    path = ../../templates/${name};
  });
}
