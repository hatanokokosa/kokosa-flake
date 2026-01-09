{pkgs, ...}: {
  users.users.hatano = {
    home = "/home/hatano";
    isNormalUser = true;
    shell = pkgs.fish;
    group = "users";
    extraGroups = [
      "networkmanager"
      "libvirtd"
      "kvm"
    ];
    packages = [pkgs.papirus-icon-theme];
  };

  environment.variables.EDITOR = "nvim";
}
