{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Python
    python313
    ruff
  ];
}
