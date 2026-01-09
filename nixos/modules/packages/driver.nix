{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Driver
    hid-bpf-uclogic
    huion-switcher
    hid-tools
  ];
}
