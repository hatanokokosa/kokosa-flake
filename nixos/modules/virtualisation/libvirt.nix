{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      onShutdown = "shutdown";
      onBoot = "start";
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = [pkgs.virglrenderer];
  programs.virt-manager.enable = true;
}
