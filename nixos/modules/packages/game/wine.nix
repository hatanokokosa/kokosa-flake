{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Wine & Proton
    wineWow64Packages.full
    winePackages.fonts
    prismlauncher
    protonplus
    winetricks
    wineasio
    bottles
    scanmem
    clinfo
    vkd3d
    dxvk
  ];
}
