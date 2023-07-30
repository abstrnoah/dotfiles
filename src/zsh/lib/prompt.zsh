# usage: source path/to/me.zsh

br_host_prompt() {
    _br_is_ssh && print -P '%M'
}

br_torified_prompt() {
    _br_is_torified && echo -n '😈 '
}
