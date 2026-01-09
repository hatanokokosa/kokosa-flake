{...}: {
  security.rtkit.enable = true;

  services.pipewire = {
    pulse.enable = true;
    jack.enable = true;
    enable = true;
    alsa = {
      support32Bit = true;
      enable = true;
    };
  };
}
