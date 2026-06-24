{config, pkgs, lib, ...}: let
  configTemplate = pkgs.writeText "mihomo-config.template.yaml" ''
    mixed-port: 7890
    tproxy-port: 7895
    allow-lan: true
    bind-address: "*"
    mode: rule
    log-level: info
    ipv6: true
    routing-mark: 255

    external-controller: 127.0.0.1:9090

    profile:
      store-selected: true
      store-fake-ip: true

    tun:
      enable: false

    dns:
      enable: true
      listen: 0.0.0.0:1053
      ipv6: true
      enhanced-mode: fake-ip
      fake-ip-range: 198.18.0.1/16
      fake-ip-filter:
        - "*.lan"
        - "*.local"
        - "*.localhost"
        - "*.home.arpa"
        - localhost.ptlogin2.qq.com
        - "*.msftconnecttest.com"
        - "*.msftncsi.com"
      default-nameserver:
        - 223.5.5.5
        - 119.29.29.29
      nameserver:
        - 223.5.5.5
        - 119.29.29.29
      fallback:
        - 1.1.1.1
        - 8.8.8.8
      fallback-filter:
        geoip: true
        geoip-code: CN
        geosite:
          - gfw

    sniffer:
      enable: true
      sniff:
        TLS:
          ports: [443, 8443]
        HTTP:
          ports: [80, 8080-8880]
      force-dns-mapping: true
      parse-pure-ip: true
      override-destination: true

    rule-providers:
      reject:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/reject.txt"
        path: ./rulesets/reject.yaml
        interval: 86400
      icloud:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/icloud.txt"
        path: ./rulesets/icloud.yaml
        interval: 86400
      apple:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/apple.txt"
        path: ./rulesets/apple.yaml
        interval: 86400
      google:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/google.txt"
        path: ./rulesets/google.yaml
        interval: 86400
      proxy:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/proxy.txt"
        path: ./rulesets/proxy.yaml
        interval: 86400
      direct:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/direct.txt"
        path: ./rulesets/direct.yaml
        interval: 86400
      private:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/private.txt"
        path: ./rulesets/private.yaml
        interval: 86400
      gfw:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/gfw.txt"
        path: ./rulesets/gfw.yaml
        interval: 86400
      greatfire:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/greatfire.txt"
        path: ./rulesets/greatfire.yaml
        interval: 86400
      tld-not-cn:
        type: http
        behavior: domain
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/tld-not-cn.txt"
        path: ./rulesets/tld-not-cn.yaml
        interval: 86400
      telegramcidr:
        type: http
        behavior: ipcidr
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/telegramcidr.txt"
        path: ./rulesets/telegramcidr.yaml
        interval: 86400
      cncidr:
        type: http
        behavior: ipcidr
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/cncidr.txt"
        path: ./rulesets/cncidr.yaml
        interval: 86400
      lancidr:
        type: http
        behavior: ipcidr
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/lancidr.txt"
        path: ./rulesets/lancidr.yaml
        interval: 86400
      applications:
        type: http
        behavior: classical
        url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/applications.txt"
        path: ./rulesets/applications.yaml
        interval: 86400

    proxy-providers:
      subscribe:
        type: http
        url: "__SUBSCRIPTION_URL__"
        path: ./proxy-providers/subscribe.yaml
        interval: 86400
        health-check:
          enable: true
          url: https://www.gstatic.com/generate_204
          interval: 300

    proxy-groups:
      - name: Proxy
        type: select
        use:
          - subscribe
        proxies:
          - DIRECT
      - name: Domestic
        type: select
        proxies:
          - DIRECT
      - name: Others
        type: select
        proxies:
          - Proxy
          - DIRECT

    rules:
      - RULE-SET,applications,Domestic
      - DOMAIN,clash.razord.top,Domestic
      - DOMAIN,yacd.metacubex.one,Domestic
      - DOMAIN,d.metacubex.one,Domestic
      - RULE-SET,private,Domestic,no-resolve
      - RULE-SET,reject,REJECT
      - RULE-SET,icloud,Domestic
      - RULE-SET,apple,Domestic
      - RULE-SET,google,Proxy
      - RULE-SET,proxy,Proxy
      - RULE-SET,direct,Domestic
      - RULE-SET,lancidr,Domestic,no-resolve
      - RULE-SET,cncidr,Domestic,no-resolve
      - RULE-SET,telegramcidr,Proxy,no-resolve
      - GEOIP,lan,Domestic,no-resolve
      - GEOIP,cn,Domestic
      - MATCH,Others
  '';
in {
  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    webui = pkgs.zashboard;
    configFile = "/var/lib/private/mihomo/config.yaml";
  };

  systemd.services.mihomo = {
    serviceConfig = {
      ExecStartPre = [
        "+${pkgs.writeShellScript "mihomo-gen-config" ''
          set -e
          ${pkgs.gnused}/bin/sed \
            "s|__SUBSCRIPTION_URL__|$(cat "$CREDENTIALS_DIRECTORY/subscription-url")|" \
            ${configTemplate} \
            > /var/lib/private/mihomo/config.yaml
        ''}"
      ];
      ExecStart = lib.mkForce (
        lib.concatStringsSep " " [
          (lib.getExe config.services.mihomo.package)
          "-d /var/lib/private/mihomo"
          "-f /var/lib/private/mihomo/config.yaml"
          (lib.optionalString (config.services.mihomo.webui != null) "-ext-ui ${config.services.mihomo.webui}")
        ]
      );
      LoadCredential = lib.mkForce [
        "subscription-url:${config.age.secrets.mihomo-subscription.path}"
      ];
    };
  };

  imports = [./tproxy.nix];
}
