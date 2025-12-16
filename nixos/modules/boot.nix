{pkgs, ...}: {
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
    ];
  };
}
