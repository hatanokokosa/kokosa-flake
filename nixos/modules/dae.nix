{
  pkgs,
  config,
  lib,
  ...
}: {
  # dae - eBPF transparent proxy
  services.dae = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };

    # DISABLE declarative config.
    # We want daed to manage the config.
    config = "";
  };

  # 1. Override dae service to read manual config file
  # 2. Use ExecStartPre to GUARANTEE the file exists and has correct permissions
  systemd.services.dae.serviceConfig = {
    ExecStartPre = lib.mkForce [ 
      "" 
      (pkgs.writeShellScript "ensure-dae-config" ''
        mkdir -p /etc/daed
        if [ ! -f /etc/daed/config.dae ]; then
          echo "Creating default dae config..."
          cat > /etc/daed/config.dae <<EOF
        global {
          tproxy_port: 12345
          lan_interface: auto
          wan_interface: auto
          log_level: info
          allow_insecure: true
          auto_config_kernel_parameter: true
        }
        routing {
          pname(NetworkManager) -> direct
          fallback: direct
        }
        EOF
        fi
        # Enforce strict 0600 permissions (required by dae)
        chmod 600 /etc/daed/config.dae
        
        # Validate config
        ${pkgs.dae}/bin/dae validate -c /etc/daed/config.dae
      '')
    ];
    ExecStart = lib.mkForce [ "" "${pkgs.dae}/bin/dae run --disable-timestamp -c /etc/daed/config.dae" ];
  };
  
  # Daed - Web dashboard
  environment.systemPackages = [pkgs.daed];
  systemd.services.daed = {
    description = "daed - dae web dashboard";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [ pkgs.dae pkgs.iptables pkgs.iproute2 ];
    serviceConfig = {
      Type = "simple";
      User = "root";
      Restart = "always";
      ExecStart = "${pkgs.daed}/bin/daed run -c /etc/daed -l 0.0.0.0:2023";
      ExecutionProfile = "unsafe";
    };
  };
  
}

