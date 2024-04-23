config@{ write-text, systemd-user-units-path, bundle }:
packages@{ gnupg, pinentry }:

bundle {
  name = "gnupg";
  packages = {
    inherit gnupg;
    gpg-agent-service = write-text {
      name = "gpg-agent-service";
      destination = (systemd-user-units-path + "/gpg-agent.service");
      text = ''
        [Unit]
        Description=GnuPG cryptographic agent and passphrase cache
        Documentation=man:gpg-agent(1)
        Requires=gpg-agent.socket

        [Service]
        ExecStart=${gnupg}/bin/gpg-agent --supervised --pinentry-program ${pinentry}/bin/pinentry
        ExecReload=${gnupg}/bin/gpgconf --reload gpg-agent
      '';
    };
  };
}
