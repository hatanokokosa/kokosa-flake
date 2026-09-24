{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    telegram-desktop
    discord
    qq
  ];
}
