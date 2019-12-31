# anenv

A configuration stack used by analyticalnoa on Ubuntu.

__Status__: Pre-alpha
__Platform__: Ubuntu 16.04 LTS

There are lots of configuration stacks out there; this one currently serves as
my `dotfiles`-ish repository and is rather dependent on the Ubuntu environment.

The initial goal is to just document my Linux setup and make it easy to
re-install all or some of the packages and configuration that I use on a new
machine when needed, so I never have to go re-querying the web to recall how I
got a particular utility working.

The longer-term goal is to create a nice framework for others to version control
and organize their Linux/Unix setup. Obviously there are plenty of package
managers out there, but the fact is that 

but it's impossible to get away with using just one, so this
will serve as a as

The "stack" refers to the set of packages configured by this repository. The
idea is that if a package is in the stack, this repository should serve as the The `packages` directory contains configuration for each package in the stack;
the `share` directory contains common files.

## Stack Table

The `stack.tsv` file catalogues the contents of the stack. The table has the
following fields:
- `package`: name of the package.
- `priority`: one of
    - `required`: the stack probably will break without it.
    - `optional`: the stack will function without it, but you might have a
      dependency issue.
    - `extra`: something experimental or silly.


## Dependencies

The listed versions are known to work properly.

#### Required
- zsh 5.1
- ranger 1.9
- python 3.5
- tmux 2.0,2.1
- tmuxinator 0.7
- htop 2.0.1
- xclip 0.12
- xbaclight 1.2.1
- git 2.21.0

#### Optional
- thefuck 3.29
- i3wm 4.11
- papis 0.8.2
- visidata 1.5.2
