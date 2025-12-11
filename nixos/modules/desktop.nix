{pkgs, ...}: {
  # KDE Plasma
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      wacom.enable = true;
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
      enable = true;
      enable32Bit = true;
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # SDDM
  services.displayManager.sddm.settings = {
    Theme = {
      Font = "Space Grotesk";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
