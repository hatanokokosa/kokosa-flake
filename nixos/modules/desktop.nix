{pkgs, ...}: {
  # KDE Plasma
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    xserver = {
      videoDrivers = ["amdgpu"];
      wacom.enable = true;
      enable = true;
    };
  };

  # Exclude Packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-workspace-wallpapers
    gwenview
    discover
    konsole
    okular
    elisa
  ];

  programs.niri.enable = false;

  # Hardware
  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    pulse.enable = true;
    jack.enable = true;
    enable = true;
    alsa = {
      support32Bit = true;
      enable = true;
    };
  };

  # SDDM
  services.displayManager.sddm.settings = {
    Theme = {
      Font = "Space Grotesk";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  xdg.portal.enable = true;
}
