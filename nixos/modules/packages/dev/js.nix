{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # JS/TS
    nodePackages.typescript-language-server
    bun
  ];
}
