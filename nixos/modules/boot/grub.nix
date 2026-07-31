{...}: {
  boot.loader = {
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
}
