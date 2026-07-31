{...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    http-connections = 20;
    connect-timeout = 10;
    fallback = true;
  };
}
