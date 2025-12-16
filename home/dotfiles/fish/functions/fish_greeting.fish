function fish_greeting
  set -l colors 89b4fa b4befe cdd6f4 d9e0ee
  set -l random_color $colors[(random 1 (count $colors))]
  set_color $random_color
  printf "▓██ ▄█▀ ▒█████   ██ ▄█▀ ▒█████    █████   ██▄       \n"
  printf "▓██▄█▒ ▒██▒  ██▒ ██▄█▒ ▒██▒  ██▒▒██    ▒ ▒████▄     \n"
  printf "▓███▄░ ▒██░  ██▒▓███▄░ ▒██░  ██▒░ ▓██▄   ▒██  ▀█▄   \n"
  printf "▓██ █▄ ▒██   ██░▓██ █▄ ▒██   ██░  ▒   ██▒░██▄▄▄▄██  \n"
  printf "▒██▒ █▄░ ████▓▒░▒██▒ █▄░ ████▓▒░▒██████▒▒ ▓█   ▓██▒ \n"
  printf "▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░ ▒▒   ▓▒█░ \n"
  printf "░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░  ▒   ▒▒ ░ \n"
  printf "░  ░ ░ ░ ░ ░    ░  ░ ░ ░   ░ ▒     ░       ░   ▒    \n"
  printf "    ░       ░          ░     ░ ░           ░   ░  \n\n"
  set_color normal
end
