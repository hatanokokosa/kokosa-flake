{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors
    nur.repos.novel2430.wpsoffice-365
    antigravity-fhs
    evil-helix
    neovim
  ];
}
