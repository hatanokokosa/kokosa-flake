{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hid-tools
  ];
}
