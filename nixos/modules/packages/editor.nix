{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nur.repos.novel2430.wpsoffice-365
    antigravity-fhs
    evil-helix
    zed-editor
    neovim
  ];
}
