{...}: {
  services.v2raya.enable = false;
  services.openssh.enable = true;
  services.flatpak.enable = true;

  programs = {
    kdeconnect.enable = true;
    nano.enable = false;
    adb.enable = true;
  };
}
