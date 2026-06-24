{
  config,
  pkgs,
  ...
}: let
  mihomoUid = 995;
  tproxyPort = 7895;
  dnsPort = 1053;
  fwmark = "0x1";
  rtTable = "100";

  nftRules = pkgs.writeText "mihomo-tproxy.nft" ''
    table inet mihomo {
      set private4 {
        type ipv4_addr
        flags interval
        elements = {
          0.0.0.0/8,
          10.0.0.0/8,
          127.0.0.0/8,
          169.254.0.0/16,
          172.16.0.0/12,
          192.168.0.0/16,
          224.0.0.0/4,
          240.0.0.0/4
        }
      }

      set private6 {
        type ipv6_addr
        flags interval
        elements = {
          ::/128,
          ::1/128,
          ::ffff:0:0:0/96,
          fe80::/10,
          fc00::/7,
          ff00::/8,
          2001:db8::/32
        }
      }

      chain prerouting {
        type filter hook prerouting priority mangle; policy accept;
        ip daddr @private4 return
        ip6 daddr @private6 return
        meta l4proto { tcp, udp } tproxy ip to 127.0.0.1:${toString tproxyPort} meta mark set ${fwmark} accept
        meta l4proto { tcp, udp } tproxy ip6 to [::1]:${toString tproxyPort} meta mark set ${fwmark} accept
      }

      chain output {
        type route hook output priority mangle; policy accept;
        ip daddr @private4 return
        ip6 daddr @private6 return
        meta skuid ${toString mihomoUid} return
        meta l4proto { tcp, udp } meta mark set ${fwmark}
      }
    }

    table ip mihomo_nat {
      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;
        udp dport 53 redirect to :${toString dnsPort}
        tcp dport 53 redirect to :${toString dnsPort}
      }
    }

    table ip6 mihomo_nat {
      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;
        udp dport 53 redirect to :${toString dnsPort}
        tcp dport 53 redirect to :${toString dnsPort}
      }
    }
  '';

  cleanupScript = pkgs.writeShellScript "mihomo-tproxy-cleanup" ''
    set -e
    ${pkgs.nftables}/bin/nft delete table inet mihomo 2>/dev/null || true
    ${pkgs.nftables}/bin/nft delete table ip mihomo_nat 2>/dev/null || true
    ${pkgs.nftables}/bin/nft delete table ip6 mihomo_nat 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip rule del fwmark ${fwmark} table ${rtTable} 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip route flush table ${rtTable} 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip -6 rule del fwmark ${fwmark} table ${rtTable} 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip -6 route flush table ${rtTable} 2>/dev/null || true
  '';
in {
  assertions = [
    {
      assertion = config.services.mihomo.enable;
      message = "mihomo-tproxy-setup requires services.mihomo.enable = true";
    }
  ];

  boot.kernel.sysctl."net.ipv4.conf.all.route_localnet" = 1;

  systemd.services.mihomo-tproxy-setup = {
    description = "Mihomo TProxy nftables routing";
    before = ["mihomo.service"];
    bindsTo = ["mihomo.service"];
    requiredBy = ["mihomo.service"];
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        "-+${pkgs.nftables}/bin/nft delete table inet mihomo"
        "-+${pkgs.nftables}/bin/nft delete table ip mihomo_nat"
        "-+${pkgs.nftables}/bin/nft delete table ip6 mihomo_nat"
      ];
      ExecStart = [
        "+${pkgs.nftables}/bin/nft -f ${nftRules}"
        "+${pkgs.iproute2}/bin/ip rule add fwmark ${fwmark} table ${rtTable}"
        "+${pkgs.iproute2}/bin/ip route add local 0.0.0.0/0 dev lo table ${rtTable}"
        "+${pkgs.iproute2}/bin/ip -6 rule add fwmark ${fwmark} table ${rtTable}"
        "+${pkgs.iproute2}/bin/ip -6 route add local ::/0 dev lo table ${rtTable}"
      ];
      ExecStop = ["+${cleanupScript}"];
      CapabilityBoundingSet = ["CAP_NET_ADMIN"];
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };
}
