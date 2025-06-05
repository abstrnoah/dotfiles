# THIS MODULE IS TODO
* At present, `flake.modules.<name>`s are arbitrary modules.
* In future, we'll need to figure out how to evaluate these modules and wire them to the appropriate flake outputs like nixosConfigurations etc.

# FOR SANITY:
* Every file in `./modules/` should be a _flake_ level module.
* "Feature" modules (e.g. vim or bluetooth or fonts) MUST be machine-agnostic. Machines are clients of features in the following sense.
    * Features MUST NOT depend substantially specific machines (i.e. may use `hostname` string to setup a statusline, but may not case off of `hostname`).
    * Features MAY depend on `system`.
    * In practice, we want to support the pattern that a "machine" module simply imports a feature and assumes the feature can use the context to figure out how to install itself.
    * This is meant to promote the pattern of having most logic occur inside the brumal module, rather than at the flake level. That is, rather than having a feature set a bunch of `flake.modules.nixos.<name>.<stuff>` (requiring the feature to know about each `<name>`), the feature can do most (if not all) of its work inside of `flake.modules.brumal.<feature>`.
    * This does mean features may have to delegate based on the value of `distro`. But I hope this is superior to the alternative.
* Maybe a more general principle which implies the last: A module should view itself as a "feature" which must decide how to configure itself dependent on the current machine on which it finds itself (viz. `config`).
    * This is _different_ from how flake-level modules view themselves (e.g. a single _file_ in the `./modules/` directory), whose `config` is _outside_ of a particular machine, instead specifying the set of all machines.

# ARGUMENTS:
* system (should equal system option if set; in below arguments, system selected)
* packages
* library
* config (is completely SEPARATE from flake config)

# OPTIONS:
* hostname
* system
* owner : user
* users.<name>
* legacyDotfiles
* nixos
* distro

# TO DO LATER
