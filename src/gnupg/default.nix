config@{ writeTextFile, systemd-user-units-path, bundle, dotfiles-out-path }:
packages@{ gnupg, pinentry }:

let
  gpg-agent-service = writeTextFile {
    name = "gpg-agent-service";
    text = ''
      [Unit]
      Description=GnuPG cryptographic agent and passphrase cache
      Documentation=man:gpg-agent(1)
      Requires=gpg-agent.socket

      [Service]
      ExecStart=${gnupg}/bin/gpg-agent --supervised
      ExecReload=${gnupg}/bin/gpgconf --reload gpg-agent
    '';
    destination = systemd-user-units-path + "/gpg-agent.service";
  };
  gpg-agent-conf = writeTextFile {
    name = "gpg-agent-conf";
    text = "pinentry-program ${pinentry}/bin/pinentry";
    destination = dotfiles-out-path + "/gpg-agent.conf";
  };
in bundle "gnupg" [ gnupg gpg-agent-service gpg-agent-conf ]
