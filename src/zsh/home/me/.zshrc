# zshrc

# TODO overhaul function names, ancient '_' prefixes are dumb and conflict with
# comp.

# Pull in native fpath that Nix's zsh probably misses.
fpath=(
    /usr/share/zsh/functions
    /usr/local/share/zsh/site-functions
    /usr/share/zsh/vendor-functions
    /usr/share/zsh/vendor-completions
    $fpath
)

# SETUP {{{1
# TODO learn about autoload lol
source "${NIXPHILE_ENV}/lib/utilities.zsh"
source "${NIXPHILE_ENV}/lib/prompt.zsh"

# EXPORTED ENVIRONMENT {{{1
export KEYTIMEOUT=1
export GPG_TTY="$(tty)"

export BR_REPOROOT="${HOME}/repository"

# FZF {{{2
# The way we employ this variable, it should be applicable to all uses of fzf.
export FZF_DEFAULT_OPTS=$(_br_join " " \
    "--border" \
    "--reverse" \
    "--bind change:first" \
    "--bind tab:replace-query" \
    "--bind alt-enter:print-query" \
    "--bind ctrl-space:toggle" \
    "--bind ctrl-t:toggle-all" \
    "--bind ctrl-a:select-all" \
    "--bind ctrl-d:accept"
)

_br_command_exists bat && {
    export BR_FZF_VIEWER='bat --style=numbers --color=always --line-range :500 {}'
} || {
    export BR_FZF_VIEWER='cat {}'
}

# If fd is missing, then fzf should use its own default (probably find).
_br_command_exists fd && {
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
}

# In addition to controlling the fzf-provided CTRL_T widget, this should serve
# as the default configuration for any file-related fzf.
export FZF_CTRL_T_OPTS="--preview '${BR_FZF_VIEWER}'"

# Ditto, for directory-related fzf.
# export FZF_ALT_C_OPTS= # just FZF_DEFAULT_OPTS for now

# export FZF_CTRL_R_OPTS= # just FZF_DEFAULT_OPTS for now

export FZF_COMPLETION_OPTS="--height 60%"

# PROMPT HELPERS {{{1


# GLOBALS {{{1
BR_PROMPTCHAR='>'
NL=$'\n'

# PARAMETERS {{{1
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=2000
PROMPT_0="$(br_nix_prompt)%B${BR_PROMPTCHAR}%b "
PROMPT_1="$(_br_join " " '%s%B%n' "$(br_host_prompt)" '%75<..<%~%b %? %#')"
PROMPT="${PROMPT_1}${NL}${PROMPT_0}"

# OPTIONS {{{1
setopt append_history
setopt extended_glob
setopt no_beep
setopt no_match
setopt no_multios
setopt notify
setopt prompt_cr prompt_sp
setopt hist_ignore_space
setopt pipe_fail

# COMPLETIONS {{{1
# See zshcompsys(1).
autoload -Uz compinit
compinit

# Fzf completions.
test -f "${NIXPHILE_ENV}/share/fzf/completion.zsh" && _br_command_exists fzf && {
    source "${NIXPHILE_ENV}/share/fzf/completion.zsh"
}


# FUNCTIONS {{{1
_br_command_exists tmux && {
    _br_reload_tmux () {
        _br_require tmux || return
        tmux source-file ~/.tmux.conf
    }
}

_br_command_exists xclip && {
    Y() {
        xclip -selection clipboard
    }

    P() {
        xclip -selection clipboard -o
    }
}

_br_command_exists tmux tmuxinator && {
    _br_tmux_go_last() {
        tmux a >&2 2>/dev/null || tmuxinator main
    }
    alias T='_br_tmux_go_last'
    alias mux=tmuxinator
}

_br_command_exists xdg-open && {
    br_open () { # <path to xdg-open-able file>
        # Suffix '&!' means 'disown' in zsh.
        xdg-open "${1}" &!
    }
    alias O='br_open'
}

_br_command_exists bat && {
    cat() {
        bat --paging=never --plain "${@}"
    }

    bathelp() {
        bat --plain --language help "${@}"
    }
    help() {
        ("${@}" -h || "${@}" --help) 2>&1 | bathelp
    }

    _br_command_exists batman && {
        man() {
            batman "${@}"
        }
    }

    _br_command_exists batwatch && {
        gitwatch() {
            local _num_commits=$(($(tput lines) - 5))
            batwatch \
                --plain -lgitlog \
                -x \
                git log \
                --oneline --decorate --graph --all \
                -n ${_num_commits} \
                "${@}"
        }
    }
}

br_fd() {
    fd --hidden --follow --exclude ".git" "${@}"
}

_br_list_git_roots() {
    # TODO handle bare repositories.
    fd --hidden --prune --type d '^\.git$' . "${1:-.}" | sed 's:/\.git$::'
}

_br_list_paths() {
    fd --hidden --follow --exclude ".git" . "${1}"
}

_br_list_files() {
    fd --hidden --follow --exclude ".git" --type f . "${1}"
}

_br_list_dirs() {
    fd --hidden --follow --exclude ".git" --type d . "$1"
}

_br_command_exists torsocks && {
    br_torshell() {
        BR_NOMUX=1 torsocks --shell
    }
}

alias _fzf_compgen_path='_br_list_paths'
alias _fzf_compgen_dir='_br_list_dirs'

alias tomb='sudo tomb'
alias pass=' pass'

# disable timer tmux integration
alias timer='TMUX= timer'

pastebin() {
    curl -X PUT -T - "https://transfer.sh/${1}"
    echo
}

if _br_command_exists nix; then
    alias nix='IN_NIX=1 nix'
fi

# experiments TODO

oops() {
    echo "$@" >/dev/stderr
    return 1
}

fzf-todotxt() {
    local todotxt="$(bat ~/.config/ttdl/ttdl.toml | toml2json | jq -r '"\(.global.filename)/todo.txt"')"
    bat "$todotxt" \
    | rargs echo {LN} {0} \
    | fzf -m \
    | rargs echo {1} \
    | paste -s -d ,
}

ttdl-filter() {
    if test "$#" -eq 0; then
        oops "Missing argment"
    fi
    tail -n+3 | head -n-2 \
    | "$@" \
    | rargs -p '\s*(\d+)' echo {1} \
    | paste -s -d ,
}

ttdl-filter-list() {
    ttdl-filter "$@" \
    | rargs ttdl list --all {0}
}

ttdl-agf() {
    if test "$#" -ne 1; then oops "Must have exactly one argument"; fi
    ttdl-filter-list ag -F "$1"
}

fzf-ttdl() {
    ttdl-filter fzf -m
}


ttdl-edit() {
    local todotxt="$(bat ~/.config/ttdl/ttdl.toml | toml2json | jq -r '"\(.global.filename)/todo.txt"')"
    local id="$1"
    shift
    vim "$todotxt" "+$id" "$@"
}

ttdl-all() {
    ttdl list --all --completed none "$@"
}

ttdl-unsorted() {
    ttdl-all --pri none "$@"
}

ttdl-now() {
    ttdl list --pri x+ "$@"
}

export NNN_PLUG='y:-!readlink -f "$nnn" | xclip -selection clipboard*;p:-!bat "$nnn"'
export NNN_OPTS='A'
export NNN_BMS="b:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/bookmarks;s:$HOME/store;d:$HOME/Downloads"
# From https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_sh_zsh
n()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}


# KEY BINDINGS {{{1

_br_command_exists fzf && {
    source "${NIXPHILE_ENV}/share/fzf/key-bindings.zsh" &>/dev/null \
    || source ~/.local/share/fzf/key-bindings.zsh \
    && {
        bindkey -M viins -r '\ec'
        bindkey -M vicmd -r '\ec'
        bindkey -M viins '^G' fzf-cd-widget
        bindkey -M vicmd '^G' fzf-cd-widget
    }
} || {
    bindkey -M viins "^r" history-incremental-pattern-search-backward
}

# Select'viins' and link to 'main' as default (see zshzle(1)).
bindkey -v

bindkey -M viins "^ " push-line-or-edit
bindkey -M vicmd "^ " push-line-or-edit

# ENTER HOOK {{{1
test -z "${TMUX}" && test -z "${BR_NOMUX}" && ! _br_is_ssh \
    && _br_command_exists _br_tmux_go_last \
    && {
    _br_tmux_go_last
}

# MODELINE {{{1
# vim:ft=zsh:fdm=marker:fmr={{{,}}}:fen:tw=80:et:ts=4:sts=4:sw=0:
