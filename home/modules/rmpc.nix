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

    # rmpc config - Catppuccin Latte with Rosewater accent
    xdg.configFile."rmpc/config.ron".text = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        address: "127.0.0.1:6600",
        default_album_art_path: None,
        draw_borders: false,
        show_song_table_header: false,
        symbols: (song: "🎵", dir: "📁", playlist: "🎼", marker: "\u{e0b0}"),

        layout: Split(
          direction: Vertical,
          panes: [
            (pane: Pane(Header), size: "1"),
            (pane: Pane(TabContent), size: "100%"),
            (pane: Pane(ProgressBar), size: "1"),
          ],
        ),

        tabs: [
          (
            name: "Queue",
            pane: Split(
              direction: Horizontal,
              panes: [(size: "60%", pane: Pane(Queue)), (size: "40%", pane: Pane(AlbumArt))],
            ),
          ),
          (name: "Directories", pane: Pane(Directories)),
          (name: "Artists", pane: Pane(Artists)),
          (name: "Album Artists", pane: Pane(AlbumArtists)),
          (name: "Albums", pane: Pane(Albums)),
          (name: "Playlists", pane: Pane(Playlists)),
          (name: "Search", pane: Pane(Search)),
        ],

        // Catppuccin Latte + Rosewater
        // Base: #eff1f5, Mantle: #e6e9ef, Text: #4c4f69
        // Rosewater: #dc8a78, Flamingo: #dd7878, Sapphire: #04a5e5, Yellow: #df8e1d
        // Overlay0: #9ca0b0

        progress_bar: (
          symbols: ["", "", "⭘", " ", " "],
          track_style: (bg: "#e6e9ef"),
          elapsed_style: (fg: "#dc8a78", bg: "#e6e9ef"),
          thumb_style: (fg: "#dc8a78", bg: "#e6e9ef"),
        ),

        scrollbar: (
          symbols: ["│", "█", "▲", "▼"],
          track_style: (),
          ends_style: (),
          thumb_style: (fg: "#dc8a78"),
        ),

        browser_column_widths: [20, 38, 42],
        text_color: "#4c4f69",
        background_color: "#eff1f5",
        header_background_color: "#e6e9ef",
        modal_background_color: None,
        modal_backdrop: false,

        tab_bar: (
          active_style: (fg: "#eff1f5", bg: "#dc8a78", modifiers: "Bold"),
          inactive_style: (),
        ),

        borders_style: (fg: "#9ca0b0"),
        highlighted_item_style: (fg: "#dc8a78", modifiers: "Bold"),
        current_item_style: (fg: "#eff1f5", bg: "#dc8a78", modifiers: "Bold"),
        highlight_border_style: (fg: "#dc8a78"),

        song_table_format: [
          (
            prop: (kind: Property(Artist), style: (fg: "#dc8a78"), default: (kind: Text("Unknown"))),
            width: "50%",
            alignment: Right,
          ),
          (
            prop: (kind: Text("-"), style: (fg: "#dc8a78"), default: (kind: Text("Unknown"))),
            width: "1",
            alignment: Center,
          ),
          (
            prop: (kind: Property(Title), style: (fg: "#04a5e5"), default: (kind: Text("Unknown"))),
            width: "50%",
          ),
        ],

        header: (
          rows: [
            (
              left: [
                (kind: Text("["), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Property(Status(State)), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Text("]"), style: (fg: "#dc8a78", modifiers: "Bold")),
              ],
              center: [
                (kind: Property(Song(Artist)), style: (fg: "#df8e1d", modifiers: "Bold"),
                 default: (kind: Text("Unknown"), style: (fg: "#df8e1d", modifiers: "Bold"))),
                (kind: Text(" - ")),
                (kind: Property(Song(Title)), style: (fg: "#04a5e5", modifiers: "Bold"),
                 default: (kind: Text("No Song"), style: (fg: "#04a5e5", modifiers: "Bold"))),
              ],
              right: [
                (kind: Text("Vol: "), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Property(Status(Volume)), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Text("% "), style: (fg: "#dc8a78", modifiers: "Bold")),
              ],
            ),
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
            "4":       SwitchToTab("Album Artists"),
            "5":       SwitchToTab("Albums"),
            "6":       SwitchToTab("Playlists"),
            "7":       SwitchToTab("Search"),
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
          method: Auto,
          max_size_px: (width: 600, height: 600),
        ),
      )
    '';
  };
}
