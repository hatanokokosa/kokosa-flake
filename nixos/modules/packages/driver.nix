{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hid-bpf-uclogic
    huion-switcher
    hid-tools
  ];
}
