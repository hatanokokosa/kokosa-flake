{...}: {
  programs.fish.enable = true;

  # TERM in an SSH session is chosen by the client emulator (xterm-kitty,
  # xterm-ghostty); the host does not know those entries without this.
  environment.enableAllTerminfo = true;

  programs.tmux = {
    enable = true;
    # Module default "screen" drops truecolor and italics inside tmux.
    terminal = "tmux-256color";
    escapeTime = 10;
    historyLimit = 50000;
    keyMode = "vi";
    newSession = true;
    extraConfig = ''
      set -g mouse on
      set -g set-clipboard on
      set -g focus-events on
    '';
  };

  programs.mosh.enable = true;
}
