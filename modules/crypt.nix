{
  flake.modules.brumal.crypt =
    {
      packages,
      lib,
      mkCases,
      config,
      library,
      ...
    }:
    let
      pass =
        let
          pass_ = packages.pass.override {
            dmenu = packages.rofi;
            inherit pass;
          };
          pass = pass_.overrideAttrs (
            final: prev: {
              patches = prev.patches ++ [ ../src/pass/set-prompt.patch ];
            }
          );
        in
        pass.withExtensions (es: [ es.pass-otp ]);

      inherit (packages) gnupg pinentry age;

      gpg-agent-service = library.writeTextFile {
        name = "gpg-agent-service";
        destination = "/home/me/.config/systemd/user/gpg-agent.service";
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
    in
    {
      userPackages = {
        inherit
          pass
          gnupg
          pinentry
          age
          ;
      };

      legacyDotfiles = mkCases config.distro { debian = { inherit gpg-agent-service; }; };
    };
}
