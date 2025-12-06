{
  config,
  lib,
  homeFiles,
  ...
}: let
  cfg = config.my.hm.fish;
  fishFilesDir = "${homeFiles}/fish";
in {
  options.my.hm.fish = {
    enable = lib.mkEnableOption "Manage fish shell configuration via Home Manager";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."fish/fish_plugins".text = "# Managed by Home Manager.\n# Plugins are provided via Home Manager configuration.\n";
    xdg.configFile."fish/completions".source = "${fishFilesDir}/completions";
    xdg.configFile."fish/functions".source = "${fishFilesDir}/functions";
    xdg.configFile."fish/conf.d".source = "${fishFilesDir}/conf.d";

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -gx BAT_THEME "Catppuccin Latte"
        set -gx BAT_STYLE plain

        set -x SKIM_DEFAULT_OPTIONS "$SKIM_DEFAULT_OPTIONS \
        --color=fg:#4c4f69,bg:#eff1f5,matched:#ccd0da,matched_bg:#dd7878, \
        current:#4c4f69,current_bg:#bcc0cc,current_match:#eff1f5, \
        current_match_bg:#dc8a78,spinner:#40a02b,info:#8839ef, \
        prompt:#1e66f5,cursor:#d20f39,selected:#e64553, \
        header:#179299,border:#9ca0b0"

        set -g fish_color_selection white --bold --background=brblack
        set -g fish_pager_color_progress brwhite --background=cyan
        set -g fish_color_search_match white --background=brblack
        set -g fish_pager_color_prefix normal --bold --underline
        set -g fish_key_bindings fish_default_key_bindings
        set -g fish_pager_color_selected_background -r
        set -g fish_pager_color_description yellow -i
        set -g fish_color_redirection cyan --bold
        set -g fish_pager_color_completion normal
        set -g fish_color_autosuggestion brblack
        set -g fish_color_history_current --bold
        set -g fish_color_valid_path --underline
        set -g fish_color_host_remote yellow
        set -g fish_color_operator brcyan
        set -g fish_color_escape brcyan
        set -g fish_color_normal normal
        set -g fish_color_quote yellow
        set -g fish_color_command blue
        set -g fish_color_cwd_root red
        set -g fish_color_user brgreen
        set -g fish_color_comment red
        set -g fish_color_error brred
        set -g fish_color_host normal
        set -g fish_color_param cyan
        set -g fish_color_status red
        set -g fish_color_cancel -r
        set -g fish_color_cwd green
        set -g fish_color_end green
      '';
    };
  };
}
