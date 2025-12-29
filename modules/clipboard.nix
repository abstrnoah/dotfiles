{
  flake.nixosModules.base =
    { pkgs, config, ... }:
    let
      cfg = config.brumal.clipboard;
      k = config.brumal.i3wm.keys;
    in
    {
      brumal.clipboard.package = pkgs.xclip;
      brumal.clipboard.selection = "clipboard";
      brumal.clipboard.yank = "${cfg.package}/bin/xclip -in -selection ${cfg.selection}";
      brumal.clipboard.paste = "${cfg.package}/bin/xclip -out -selection ${cfg.selection}";

      brumal.tmux.conf = ''
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe "${cfg.yank}"
        bind C-p paste-buffer -p
      '';

      brumal.bash.profile = ''
        Y() {
          ${cfg.yank}
        }

        P() {
          ${cfg.paste}
        }
      '';

      brumal.i3wm.body.directives = [
        ''bindsym --release ${k.mod}+c exec "${pkgs.imagemagick}/bin/import png:- | ${cfg.yank} -t image/png"''
      ];
    };
}
