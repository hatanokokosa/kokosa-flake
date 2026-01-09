{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # JS/TS
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.nodejs
    nodePackages.pnpm
  ];
}
