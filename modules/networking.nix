{
  flake.nixosModules.base =
    {
      config,
      ownerName,
      pkgs,
      library,
      ...
    }:
    let
      secrets = config.age.secrets;
    in
    {
      environment.systemPackages = [
        pkgs.dig
        pkgs.net-tools
      ];
      users.users.${ownerName}.extraGroups = [ "networkmanager" ];
      networking.useDHCP = library.mkDefault true;
      services.mullvad-vpn.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
      };
      networking.networkmanager.enable = true;
      networking.networkmanager.ensureProfiles = {
        environmentFiles = [ secrets.networkmanager.path ];
        profiles = {
          CMU-SECURE = {
            connection = {
              id = "CMU-SECURE";
              type = "wifi";
            };
            wifi = {
              mac-address-blacklist = "";
              mode = "infrastructure";
              ssid = "CMU-SECURE";
            };
            wifi-security = {
              key-mgmt = "wpa-eap";
            };
            "802-1x" = {
              eap = "peap";
              identity = "$CMU_IDENTITY";
              password = "$CMU_PSK";
              phase2-autheap = "mschapv2";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
          eduroam = {
            connection = {
              id = "eduroam";
              type = "wifi";
            };
            wifi = {
              mac-address-blacklist = "";
              mode = "infrastructure";
              ssid = "eduroam";
            };
            wifi-security = {
              key-mgmt = "wpa-eap";
            };
            "802-1x" = {
              eap = "peap";
              identity = "$EDUROAM_IDENTITY";
              password = "$EDUROAM_PSK";
              phase2-autheap = "mschapv2";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
        };
      };
    };
}
