{pkgs, ...}: {
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
}
