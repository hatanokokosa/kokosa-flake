{config, ...}: {
  services.v2raya.enable = false;

  # Syncthing

  age.secrets.syncthing-gui-password = {
    rekeyFile = ./secrets/syncthing-gui-password.age;
    owner = "hatano";
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
