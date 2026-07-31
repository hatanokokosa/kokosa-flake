{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-workspace-wallpapers
    khelpcenter
    discover
    konsole
    okular
    elisa
  ];

  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    enable = true;
  };
}
