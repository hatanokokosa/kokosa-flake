{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.rmpc;
in {
  options.my.hm.rmpc = {
    enable = lib.mkEnableOption "Enable rmpc MPD client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.rmpc];

    # rmpc config with Catppuccin Latte theme
    xdg.configFile."rmpc/config.ron".text = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      (
          address: "127.0.0.1:6600",
          theme: (
              default_album_art_path: None,
              show_song_table_header: true,
              draw_borders: true,
              browser_column_widths: [20, 38, 42],

              // Catppuccin Latte colors
              background_color: None,
              text_color: "#4c4f69",
              header_color: "#1e66f5",
              modal_background_color: None,
              tab_bar: (
                  enabled_color: "#eff1f5",
                  disabled_color: "#8c8fa1",
                  active_color: "#1e66f5",
                  active_background_color: "#ccd0da",
              ),
              borders_style: (
                  border_color: "#ccd0da",
                  border_type: "rounded",
              ),
              highlighted_item_style: (
                  foreground_color: "#1e66f5",
                  background_color: "#e6e9ef",
                  bold: false,
                  italic: false,
                  underline: false,
              ),
              current_item_style: (
                  foreground_color: "#eff1f5",
                  background_color: "#1e66f5",
                  bold: true,
                  italic: false,
                  underline: false,
              ),
              highlight_border_style: (
                  border_color: "#1e66f5",
                  border_type: "rounded",
              ),
              progress_bar: (
                  symbols: ["━", "━", "─"],
                  track_color: "#ccd0da",
                  elapsed_color: "#1e66f5",
                  thumb_color: "#1e66f5",
              ),
              scrollbar: (
                  symbols: ["│", "█", "█"],
                  track_color: "#ccd0da",
                  thumb_color: "#8c8fa1",
              ),
              song_table_format: [
                  (prop: (kind: Property(Artist), style: (foreground_color: "#8839ef"), default: (kind: Text("<Unknown>")))),
                  (prop: (kind: Text(" - "))),
                  (prop: (kind: Property(Title), style: (foreground_color: "#4c4f69"), default: (kind: Property(Filename)))),
                  (prop: (kind: Text("  "))),
                  (prop: (kind: Property(Duration), style: (foreground_color: "#179299"), alignment: Right)),
              ],
          ),
          keybinds: (
              global: {
                  ":":       CommandMode,
                  "q":       Quit,
                  "~":       ShowHelp,
                  "1":       SwitchToTab("Queue"),
                  "2":       SwitchToTab("Directories"),
                  "3":       SwitchToTab("Artists"),
                  "4":       SwitchToTab("Playlists"),
                  "5":       SwitchToTab("Search"),
              },
              navigation: {
                  "j":       Down,
                  "k":       Up,
                  "h":       Left,
                  "l":       Right,
                  "g":       Top,
                  "G":       Bottom,
                  "Ctrl+d":  DownHalf,
                  "Ctrl+u":  UpHalf,
                  "Enter":   Confirm,
                  "Esc":     Close,
                  "/":       EnterSearch,
                  "n":       NextResult,
                  "N":       PreviousResult,
              },
              queue: {
                  "d":       DeleteSong,
                  "D":       Clear,
                  "a":       AddToPlaylist,
                  "i":       ShowInfo,
                  "c":       JumpToCurrent,
              },
              browser: {
                  "a":       AddAll,
                  "r":       AddAllReplace,
                  "Enter":   Add,
              },
          ),
          status_update_interval_ms: 1000,
          select_current_song_on_change: true,
          album_art: (
              method: Kitty,
              max_size_px: (width: 600, height: 600),
          ),
      )
    '';
  };
}
