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

    # rmpc theme - Catppuccin Latte + Rosewater (based on official Macchiato theme)
    # Color mapping:
    # Macchiato #24273a (Base)     -> Latte #eff1f5
    # Macchiato #1e2030 (Mantle)   -> Latte #e6e9ef
    # Macchiato #c6a0f6 (Mauve)    -> Latte #dc8a78 (Rosewater)
    # Macchiato #b7bdf8 (Lavender) -> Latte #dc8a78 (Rosewater)
    # Macchiato #7dc4e4 (Sapphire) -> Latte #04a5e5
    # Macchiato #eed49f (Yellow)   -> Latte #df8e1d
    # Macchiato #cad3f5 (Text)     -> Latte #4c4f69
    # Macchiato #6e738d (Overlay0) -> Latte #9ca0b0
    # Macchiato black              -> Latte #eff1f5

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
            (
              pane: Pane(Header),
              size: "1",
            ),
            (
              pane: Pane(TabContent),
              size: "100%",
            ),
            (
              pane: Pane(ProgressBar),
              size: "1",
            ),
          ],
        ),
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
        tab_bar: (active_style: (fg: "#eff1f5", bg: "#dc8a78", modifiers: "Bold"), inactive_style: ()),
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
                (kind: Text("]"), style: (fg: "#dc8a78", modifiers: "Bold"))
              ],
              center: [
                (kind: Property(Song(Artist)), style: (fg: "#df8e1d", modifiers: "Bold"),
                  default: (kind: Text("Unknown"), style: (fg: "#df8e1d", modifiers: "Bold"))
                ),
                (kind: Text(" - ")),
                (kind: Property(Song(Title)), style: (fg: "#04a5e5", modifiers: "Bold"),
                  default: (kind: Text("No Song"), style: (fg: "#04a5e5", modifiers: "Bold"))
                )
              ],
              right: [
                (kind: Text("Vol: "), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Property(Status(Volume)), style: (fg: "#dc8a78", modifiers: "Bold")),
                (kind: Text("% "), style: (fg: "#dc8a78", modifiers: "Bold"))
              ]
            )
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
          (
            name: "Directories",
            pane: Pane(Directories),
          ),
          (
            name: "Artists",
            pane: Pane(Artists),
          ),
          (
            name: "Album Artists",
            pane: Pane(AlbumArtists),
          ),
          (
            name: "Albums",
            pane: Pane(Albums),
          ),
          (
            name: "Playlists",
            pane: Pane(Playlists),
          ),
          (
            name: "Search",
            pane: Pane(Search),
          ),
        ],
      )
    '';
  };
}
