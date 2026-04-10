{...}: {
  services.openssh.enable = true;
  services.flatpak.enable = true;

  programs = {
    kdeconnect.enable = true;
    nano.enable = false;
  };
}
