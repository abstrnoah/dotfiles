# module system

At this time, the following dead simple system works for me: Modules are
directory trees. We form modules from other modules by merging directory trees.
To deploy a resulting tree to, say, your home directory, use `stow`.

In the future, I might do something more advanced with templates (nixpkgs has
`substituteAll` and friends) but it hasn't been necessary.

As simple as this is, using Nix means that I can deploy dotfiles to any machine
that will run Nix. And Nix can be installed without root privileges on just
about any modern machine with a single like of code. Nixpkgs has `stow`, so we
can perform the entire deployment with Nix without root, if needed.

## features

* merge arbitrary trees
* TODO: exclude paths matching regex
* TODO: graft paths like `dot-files` to `.file`

## api

```nix
make-module =
name:
config@{
    prefix_substs ? { "dot-files" : ".file" },
    exclude_file ? ""
}:
deps:
/* output is a path to the module's resulting tree */
```

## usage

Create a file `modules.nix` in the repository root of the form

```nix
rec {
    dependency = {
        config = { exclude_file = path/to/excludes; prefix_substs = {} };
        deps = [ path/to/cool/module ]
    };
    dependent = { deps = [ dependency ] };
    ...
}
```
