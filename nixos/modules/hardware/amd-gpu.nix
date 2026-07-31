{...}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };
  hardware.amdgpu.opencl.enable = true;
}
