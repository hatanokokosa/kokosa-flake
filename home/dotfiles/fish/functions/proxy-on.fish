function proxy-on
    set -gx http_proxy http://127.0.0.1:2080
    set -gx https_proxy http://127.0.0.1:2080
    set -gx all_proxy socks5h://127.0.0.1:2080
    set -gx no_proxy "127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.local"
end
