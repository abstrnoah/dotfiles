{ nixpkgs, bundle }:

let
  captive-browser = nixpkgs.captive-browser;
  write_text = name: text: "${nixpkgs.writeTextDir name text}/${name}";
  config = nixpkgs.writeTextDir "home/me/.config/captive-browser.toml" ''
    # Source: https://raw.githubusercontent.com/FiloSottile/captive-browser/main/captive-browser-ubuntu-chrome.toml

    # browser is the shell (/bin/sh) command executed once the proxy starts.
    # When browser exits, the proxy exits. An extra env var PROXY is available.
    #
    # Here, we use a separate Chrome instance in Incognito mode, so that
    # it can run (and be waited for) alongside the default one, and that
    # it maintains no state across runs. To configure this browser open a
    # normal window in it, settings will be preserved.
    browser = """
        ${nixpkgs.chromium}/bin/chromium-browser \
        --user-data-dir="$HOME/.google-chrome-captive" \
        --proxy-server="socks5://$PROXY" \
        --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost" \
        --no-first-run --new-window --incognito \
        --no-default-browser-check \
        http://neverssl.com
    """

    # dhcp-dns is the shell (/bin/sh) command executed to obtain the DHCP
    # DNS server address. The first match of an IPv4 regex is used.
    # IPv4 only, because let's be real, it's a captive portal.
    #
    # `wlp3s0` is your network interface (eth0, wlan0 ...)
    #
    dhcp-dns = "nmcli dev show | grep IP4.DNS"

    # socks5-addr is the listen address for the SOCKS5 proxy server.
    socks5-addr = "localhost:1666"
  '';
in bundle "captive-browser" [ config captive-browser ]
