{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWow64Packages.full
    winePackages.fonts
    prismlauncher
    protonplus
    winetricks
    wineasio
    scanmem
    clinfo
    # heroic
    vkd3d
    dxvk
  ];
}
