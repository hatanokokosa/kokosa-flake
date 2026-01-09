{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Tele
    telegram-desktop
    qq
  ];
}
