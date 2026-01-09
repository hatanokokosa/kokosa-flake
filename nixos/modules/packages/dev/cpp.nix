{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # C/C++
    clang-tools
    clang
  ];
}
