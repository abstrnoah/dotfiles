# TODO A lot of this should be refactored, but I'm just trying a minimal working config.
top@{config, ...}:
{
  flake.machines.porcupine = {config, packages, ...}: {
    system = "x86_64-linux";
    distro = "nixos";
    hostname = "porcupine";
    owner.name = "abstrnoah";

    imports = builtins.attrValues {
      inherit (top.config.flake.modules.brumal)
      cl
      gui
      wm
      pulseaudio;
    };

    nixos = {
      imports = [
        # TODO Is this the best approach??
        ../hardware-configuration.nix
      ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "porcupine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant. QUESTION compare with networking.networkmanager.enable?

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abstrnoah = {
    isNormalUser = true;
    description = "Noah";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = builtins.attrValues config.userPackages;
    shell = packages.zsh;
  };

  programs.zsh.enable = true;

  # Allow unfree packages
#  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with packages; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    tmux
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

services.xserver.enable = true;
services.xserver.displayManager.gdm.enable = true;
services.xserver.windowManager.i3.enable = true;
services.xserver.windowManager.i3.package = packages.i3wm;



    };
  };
}
