set -g __throne_proxy_host 127.0.0.1
set -g __throne_proxy_port 2080
set -g __throne_no_proxy "127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local"

function proxy-sync
    if command -q nc; and nc -z $__throne_proxy_host $__throne_proxy_port >/dev/null 2>&1
        set -l http_url "http://$__throne_proxy_host:$__throne_proxy_port"
        set -l socks_url "socks5h://$__throne_proxy_host:$__throne_proxy_port"

        set -gx http_proxy $http_url
        set -gx https_proxy $http_url
        set -gx all_proxy $socks_url
        set -gx no_proxy $__throne_no_proxy
    else
        set -e http_proxy https_proxy all_proxy no_proxy
    end
end

proxy-sync
