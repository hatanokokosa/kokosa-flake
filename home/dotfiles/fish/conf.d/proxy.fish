set -g __throne_proxy_host 127.0.0.1
set -g __throne_proxy_port 2080
set -g __throne_no_proxy "127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local"

function proxy-sync
    if command -q nc; and nc -z $__throne_proxy_host $__throne_proxy_port >/dev/null 2>&1
        set -l http_url "http://$__throne_proxy_host:$__throne_proxy_port"
        set -l socks_url "socks5h://$__throne_proxy_host:$__throne_proxy_port"

        set -gx http_proxy $http_url https_proxy $http_url all_proxy $socks_url no_proxy $__throne_no_proxy
        set -gx HTTP_PROXY $http_url HTTPS_PROXY $http_url ALL_PROXY $socks_url NO_PROXY $__throne_no_proxy
    else
        set -e http_proxy https_proxy all_proxy no_proxy
        set -e HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
    end
end

proxy-sync
