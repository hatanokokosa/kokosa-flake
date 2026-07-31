{...}: {
  zramSwap = {
    memoryPercent = 50;
    algorithm = "zstd";
    enable = true;
  };
}
