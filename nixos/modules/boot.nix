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
      "v4l2loopback"
      "xt_TPROXY"
      "xt_owner"
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
    memoryPercent = 50;
    algorithm = "zstd";
    enable = true;
  };
}
