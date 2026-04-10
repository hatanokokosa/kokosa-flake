{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # JS/TS
    typescript-language-server
    bun
  ];
}
