{
  pkgs,
  config,
  ...
}: {
  boot = {
    # Use Kernel: linux-zen
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
      "xt_TPROXY"
      "xt_owner"
      "v4l2loopback"
    ];

    # v4l2loopback 虚拟摄像头配置
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
  };

  # Zram Swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
