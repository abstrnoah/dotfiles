{
  flake.modules.nixos.wm = {
    brumal.cfg.i3wm.body.directives = [
      ''for_window [class="(?i)^spotify$"] move window to workspace audio''
      ''for_window [class="(?i)^telegramdesktop$"] move window to workspace tele''
      ''for_window [class="(?i)discord$"] move window to workspace disc''
      ''for_window [class="(?i)^signal$"] move window to workspace sign''
      ''for_window [class="(?i)^whatsapp"] move window to workspace what''
      ''for_window [class="(?i)firefox"] move window to workspace fire''
      ''for_window [class="(?i)chromium"] move window to workspace chrom''
      ''for_window [class="(?i)jabref"] move window to workspace jabref''
    ];
  };
}
