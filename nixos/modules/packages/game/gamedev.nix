{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gdtoolkit_4
    godot
  ];
}
