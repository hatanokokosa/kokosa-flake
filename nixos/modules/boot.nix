{
  pkgs,
  config,
  ...
}: {
  boot = {
    # use kernel: linux-zen
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      grub = {
        efiSupport = true;
        device = "nodev";
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    kernelModules = [
      "v4l2loopback"
      "xt_TPROXY"
      "xt_owner"
    ];

    # v4l2loopback
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };

  # zram swap
  zramSwap = {
    memoryPercent = 50;
    algorithm = "zstd";
    enable = true;
  };
}
