{
  inputs,
  pkgs,
  ...
}: let
  opentabletdriver-q630m = pkgs.callPackage "${inputs.self}/pkgs/opentabletdriver-q630m" {};
in {
  services.xserver = {
    videoDrivers = ["amdgpu"];
    wacom.enable = false;
    enable = true;
  };

  hardware = {
    opentabletdriver = {
      enable = true;
      package = opentabletdriver-q630m;
    };

    graphics = {
      enable32Bit = true;
      enable = true;
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };
}
