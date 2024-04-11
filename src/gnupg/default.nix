config @ {
  writeTextFile
, systemd-user-units-path
, bundle
}:
packages @ {
  gnupg
, pinentry
}:

let
  gpg-agent-service = writeTextFile {
      name = "gpg-agent-service";
      text = ''
          [Unit]
          Description=GnuPG cryptographic agent and passphrase cache
          Documentation=man:gpg-agent(1)
          Requires=gpg-agent.socket

          [Service]
          ExecStart=${gnupg}/bin/gpg-agent --supervised --pinentry-program ${pinentry}/bin/pinentry
          ExecReload=${gnupg}/bin/gpgconf --reload gpg-agent
        '';
      destination = systemd-user-units-path + "/gpg-agent.service";
    };
in
  bundle "gnupg" [gnupg gpg-agent-service pinentry]
