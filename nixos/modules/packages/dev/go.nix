{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gopls
    go
  ];
}
