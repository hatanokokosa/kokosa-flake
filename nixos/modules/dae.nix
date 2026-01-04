{pkgs, ...}: {
  # dae - eBPF transparent proxy
  services.dae = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };

    config = ''
      global {
        tproxy_port: 12345
        log_level: info
        tcp_check_url: 'http://cp.cloudflare.com'
        udp_check_dns: 'dns.google.com:53'
        check_interval: 30s
        check_tolerance: 50ms
        lan_interface: auto
        wan_interface: auto
        allow_insecure: false
        auto_config_kernel_parameter: true
      }

      subscription {
        airport: 'https://your-airport.com/api/v1/client/subscribe?token=YOUR_TOKEN'
      }

      node {}

      group {
        proxy {
          filter: subtag(airport)
          policy: min_moving_avg
        }
      }

      routing {
        pname(NetworkManager, systemd-resolved, dnsmasq) -> direct
        dip(geoip:private) -> direct
        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct
        fallback: proxy
      }
    '';
  };

  # Daed - Web dashboard (http://localhost:2023)
  environment.systemPackages = [pkgs.daed];

  systemd.services.daed = {
    description = "daed - dae web dashboard";
    after = ["network.target" "dae.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.daed}/bin/daed run -c /etc/daed";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  environment.etc."daed/.keep".text = "";
}
