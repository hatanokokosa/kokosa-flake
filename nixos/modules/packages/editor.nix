{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wps-sandbox
    evil-helix
    zed-editor
    neovim
  ];
}
