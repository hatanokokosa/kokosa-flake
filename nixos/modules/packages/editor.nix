{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nur.repos.novel2430.wpsoffice-365
    evil-helix
    zed-editor
    neovim
  ];
}
