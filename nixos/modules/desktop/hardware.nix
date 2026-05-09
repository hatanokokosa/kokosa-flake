{...}: {
  services.xserver = {
    videoDrivers = ["amdgpu"];
    wacom.enable = false;
    enable = true;
  };

  hardware = {
    opentabletdriver.enable = true;

    graphics = {
      enable32Bit = true;
      enable = true;
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };
}
