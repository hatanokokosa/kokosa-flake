{...}: {
  services.xserver = {
    videoDrivers = ["amdgpu"];
    wacom.enable = true;
    enable = true;
  };

  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };
}
