{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    clang-tools
    clang
  ];
}
