{
  inputs,
  pkgs,
  ...
}: let
  driver = pkgs.callPackage "${inputs.self}/pkgs/opentabletdriver-q630m" {};
in {
  services.xserver.wacom.enable = false;
  hardware.opentabletdriver = {
    enable = true;
    package = driver;
  };
}
