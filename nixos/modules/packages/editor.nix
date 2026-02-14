{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors
    nur.repos.novel2430.wpsoffice-365
    google-antigravity
    evil-helix
    zed-editor
    neovim
  ];
}
