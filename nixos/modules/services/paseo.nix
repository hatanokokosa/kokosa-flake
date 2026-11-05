{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.paseo];

  systemd.services.paseo = {
    description = "Paseo coding agent daemon";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target" "cloudflare-warp.service"];
    after = ["network-online.target" "cloudflare-warp.service"];
    path = [config.system.path];
    environment = {
      HOME = config.users.users.hatano.home;
      PASEO_LISTEN = "100.96.0.2:6767";
      PASEO_RELAY_ENABLED = "false";
    };
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      User = "hatano";
      WorkingDirectory = config.users.users.hatano.home;
      ExecStart = "${pkgs.paseo}/bin/paseo daemon run";
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077";
    };
  };
}
