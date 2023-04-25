# qutebrowser/config.py - qutebrowser runtime configuration

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

__author__ = "abstrnoah"

# GLOBALS {{{1

# Leader keys by functionality.
_leader = ","
_leader_tab = "<Ctrl-t>"
_leader_hint = _leader + ";"

# SETUP {{{1

# Tor proxy.
# c.content.proxy = "socks://localhost:9050"
# Not available without QtWebKit backend :(.
# c.content.proxy_dns_requests = True

# Home page.
# Note that 'start_pages' is different from 'default_page'; ':home' goes to the
# former while generic opens go to the latter.
c.url.start_pages = ["http://neverssl.com/"]
_searchengines = {
    "ddg": "https://duckduckgo.com/?q={}",
    "ddg-onion": "https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion/?q={}",
}
_searchengines["DEFAULT"] = _searchengines["ddg"]
c.url.searchengines = _searchengines

# Don't load autoconfig.yml.
config.load_autoconfig(False)

# Editor (and arguments) to use for the `edit-*` commands.
c.editor.command = ["gvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]

# Position of the tab bar.
c.tabs.position = "top"

# Close tab even if it's the last tab.
c.tabs.last_close = "close"

# Autoplay sucks.
c.content.autoplay = False

# Status.
c.statusbar.show = "in-mode"
c.tabs.show = "multiple"

# # DARKMODE {{{1
c.colors.webpage.preferred_color_scheme = "dark"

# PER-DOMAIN SETTINGS {{{1
with config.pattern("https://mail.google.com/") as p:
    p.content.notifications.enabled = True
with config.pattern("https://mail.google.com?extsrc=mailto&url=%25s") as p:
    p.content.register_protocol_handler = True

with config.pattern("https://calendar.google.com/") as p:
    p.content.notifications.enabled = True
with config.pattern("https://calendar.google.com?cid=%25s") as p:
    p.content.register_protocol_handler = True

# BINDS {{{1

# Unbind some annoying keys.
config.unbind("<Ctrl-a>")

# Don't forward any keys to page unless in an insert mode.
c.input.forward_unbound_keys = "none"

# Resource config.
config.bind(_leader + "C", "config-source")

# Swap quickmark and mark for more vim-like experience.
config.bind("m", "mode-enter set_mark")
config.bind("`", "quickmark-save")

# Open current page in mpv.
config.bind(_leader + "v", "spawn mpv {url}")
# Open link in mpv.
config.bind(_leader_hint + "v", "hint all spawn mpv {hint-url}")

# Open current page in firefox (I'm sorry).
config.bind(_leader + "F", "spawn firefox {url}")

# Passthrough mode.
# <Escape> always escapes to normal.
config.bind("<Escape>", "mode-leave", mode="passthrough")
config.bind("<Ctrl-[>", "mode-leave", mode="passthrough")

# Passthrough common clipboard chords.
config.bind(_leader + "y", "fake-key <Ctrl-c>")
config.bind(_leader + "p", "fake-key <Ctrl-v>")
config.bind(_leader + "d", "fake-key <Ctrl-x>")

# Passthrough escape in normal.
config.bind(_leader + "e", "fake-key <Escape>")

# Passthrough common undo chords.
config.bind(_leader + "u", "fake-key <Ctrl-z>")
config.bind(_leader + "r", "fake-key <Ctrl-y>")

# Passthrough search.
config.bind(_leader + "/", "fake-key <Ctrl-f> ;; mode-enter insert")

# History navigation.
config.unbind("H")
config.unbind("L")
config.bind("gh", "back")
config.bind("gl", "forward")
config.bind("gH", "set-cmd-text -s :back")
config.bind("gL", "set-cmd-text -s :forward")

# Tab navigation.
config.bind(_leader + "<space>", "set-cmd-text -s :tab-select")
config.unbind("d")
config.unbind("D")
config.unbind("<Ctrl-w>")
config.unbind(_leader_tab)
config.unbind("r")
config.unbind("R")
config.bind(_leader_tab + "n", "open -t")
config.bind("A", "open -t")
config.bind(_leader_tab + "q", "tab-close")
config.bind(_leader_tab + "r", "reload")
config.bind(_leader_tab + "R", "reload -f")
# Tab movement to the end (right-most).
config.bind("gm", "tab-move -1")
# Move (give) to window, prompt.
config.bind("gD", "set-cmd-text -s :tab-give")

# Clear messages on the fly.
config.bind("cm", "clear-messages")

# Toggle status.
config.bind(_leader + "f", "config-cycle -t statusbar.show in-mode always")

# Command mode
config.bind("<Ctrl-f>", "edit-command", mode="command")
config.bind("<Ctrl-t>", "spawn --userscript toggle-select-open", mode="command")
