{pkgs, ...}: {
  # KDE plasma
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.settings = {
      Theme = {
        Font = "Space Grotesk";
      };
    };
  };

  # exclude packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-workspace-wallpapers
    khelpcenter
    discover
    konsole
    okular
    elisa
  ];

  # XDG portal
  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    enable = true;
  };
}
