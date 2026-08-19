{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    typescript-language-server
    nodejs
    pnpm
    bun
  ];
}
