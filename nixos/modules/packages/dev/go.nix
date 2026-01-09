{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Go
    gopls
    go
  ];
}
