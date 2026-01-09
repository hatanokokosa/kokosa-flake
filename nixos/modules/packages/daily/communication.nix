{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Communication
    telegram-desktop
    qq
  ];
}
