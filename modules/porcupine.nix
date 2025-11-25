top@{ config, ... }:
{
  flake.machineModules.porcupine =
    {
      library,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ top.config.flake.nixosModules.gui ];

      networking.hostName = "porcupine";
      brumal.distro = "nixos";
      system.stateVersion = "25.05"; # "Do not change this value..."
      nixpkgs.hostPlatform = library.mkDefault "x86_64-linux";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # From hardware scan:
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/b94f77a3-e5cf-42a2-92ca-b54e0565f248";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/9CBC-B8E5";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
      swapDevices = [
        { device = "/dev/disk/by-uuid/7c6b59c0-dedd-42d3-b174-e4a13231a3a8"; }
      ];
      hardware.cpu.intel.updateMicrocode = library.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.enableRedistributableFirmware = library.mkDefault true;

      # Prevent systemd from blocking for 10 seconds after resume (probably a hardware bug).
      services.fwupd.enable = true;
      systemd.globalEnvironment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
      systemd.managerEnvironment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
      # HACK
      systemd.services."systemd-suspend" = {
        serviceConfig.Type = "simple";
      };
      systemd.services."systemd-suspend-then-hibernate" = {
        serviceConfig.Type = "simple";
      };

    };
}
