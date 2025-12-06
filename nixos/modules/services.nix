{...}: {
  services.v2raya.enable = false;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "hatano";
    group = "users";
    dataDir = "/home/hatano";
    configDir = "/home/hatano/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    settings = {
      gui = {
        user = "kokosa";
        password = "wuyu1234";
      };
      folders."obsidian-vault" = {
        path = "/home/hatano/Documents/Obsidian Vault";
        devices = [];
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
