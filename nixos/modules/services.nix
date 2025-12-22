{...}: {
  services.v2raya.enable = false;

  # Syncthing
  services.syncthing = {
    configDir = "/home/hatano/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    dataDir = "/home/hatano";
    group = "users";
    user = "hatano";
    enable = true;
    settings = {
      gui = {
        password = "$2b$05$OB3G1GrL6hAyvBSDFLXuUuCDc6JbxlHfYz0Pwjmj.nj6mFtIGHMFu";
        user = "kokosa";
      };
    };
    openDefaultPorts = true;
  };

  # Podman
  virtualisation.podman.enable = true;

  # Other
  programs = {
    kdeconnect.enable = true;
    nano.enable = false;
    adb.enable = true;
  };

  services.openssh.enable = true;
  services.flatpak.enable = true;
}
