{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.fzf;

  fdBase = ''
    fd --type f --hidden --follow \
        --exclude result --exclude .codex \
        --exclude .git --exclude node_modules --exclude vendor \
        --exclude .rustup --exclude .steampath --exclude .steampid \
        --exclude .nix-defexpr --exclude .nix-profile --exclude .pki \
        --exclude target --exclude build --exclude dist --exclude .venv \
        --exclude .npm --exclude .vscode --exclude .var --exclude .themes \
        --exclude .wine --exclude .steam --exclude .cache --exclude .local \
        --exclude .cargo --exclude .dotnet --exclude .gemini --exclude .gnupg \
        --exclude .icons --exclude .java --exclude .lyrics --exclude .mozilla \
        --size -10M --max-results 3000000 --strip-cwd-prefix
  '';
in {
  options.my.hm.fzf = {
    enable = lib.mkEnableOption "Enable FZF via Home Manager";
    disableTranspose = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  # FZF Config
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [fzf fd ripgrep bat];

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;

      defaultCommand = fdBase;
      fileWidgetCommand = fdBase;

      changeDirWidgetCommand = ''
        fd --type d --hidden --follow \
            --exclude .git --exclude node_modules --exclude vendor \
            --exclude target --exclude build --exclude dist --exclude .venv \
            --exclude .cache --exclude .local --exclude .nix-profile \
            --strip-cwd-prefix
      '';

      defaultOptions = [
        "--height=40%"
        "--layout=reverse"
        "--border=sharp"
        "--preview='bat --style=plain --color=always --paging=never {}'"
        "--preview-window=right,50%,border-left"
        "--pointer=▶"
        "--marker=✓"
        "--info=inline"
      ];

      fileWidgetOptions = [
        "--preview='bat --style=plain --color=always --paging=never {}'"
        "--preview-window=right,50%,border-left"
      ];
      changeDirWidgetOptions = ["--select-1" "--exit-0"];
      historyWidgetOptions = ["--exact" "--sort"];
    };
  };
}
