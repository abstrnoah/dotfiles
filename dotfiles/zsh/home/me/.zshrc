# zshrc

# SETUP {{{1
source "${NIXPHILE_ENV}/lib/utilities.zsh"
source "${NIXPHILE_ENV}/lib/prompt.zsh"

# EXPORTED ENVIRONMENT {{{1
export KEYTIMEOUT=1

export BR_REPOROOT="${HOME}/repository"

# FZF {{{2
# The way we employ this variable, it should be applicable to all uses of fzf.
export FZF_DEFAULT_OPTS=$(_br_join " " \
    "--border" \
    "--reverse" \
    "--bind change:first" \
    "--bind tab:replace-query" \
    "--bind alt-enter:print-query" \
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
PROMPT_0="$(br_torified_prompt)%B${BR_PROMPTCHAR}%b "
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

# COMPLETIONS {{{1
# Zsh's new completions, 'zshcompsys'.
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit
# source "${BR_DOTFILES}/package/zsh/comp-mux.zsh" # TODO do i care enuf?

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
}

_br_command_exists xdg-open && {
    br_open () { # <path to xdg-open-able file>
        # Suffix '&!' means 'disown' in zsh.
        xdg-open "${1}" &!
    }
    alias O='br_open'
}

ssh() {
    test -z "${TMUX}" || _br_oops "Don't ssh from tmux, fool!" || return
    command ssh "${@}"
}

_br_command_exists bat && {
    cat() {
        bat --paging=never --plain "${@}"
    }

    bathelp() {
        bat --plain --language help "${@}"
    }
    help() {
        "${@}" -h 2>&1 | bathelp
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

alias tomb=' sudo tomb'
alias pass=' pass'

# disable timer tmux integration
alias timer='TMUX= timer'

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
