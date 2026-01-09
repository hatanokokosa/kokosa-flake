{...}: {
  imports = [
    ./hardware.nix
    ./plasma.nix
    ./locale.nix
    ./audio.nix
    ./shell.nix
    ./fonts.nix
    ./input.nix
    ./theme.nix
  ];

  powerManagement.cpuFreqGovernor = "ondemand";
}
