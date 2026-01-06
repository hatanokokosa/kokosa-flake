{
  config,
  lib,
  ...
}: let
  cfg = config.my.hm.mpd;
in {
  options.my.hm.mpd = {
    enable = lib.mkEnableOption "Enable MPD music player daemon";
    musicDirectory = lib.mkOption {
      type = lib.types.str;
      default = "~/Music";
      description = "Path to music directory";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = cfg.musicDirectory;
      playlistDirectory = "${config.xdg.dataHome}/mpd/playlists";
      dataDir = "${config.xdg.dataHome}/mpd";
      dbFile = "${config.xdg.dataHome}/mpd/database";

      extraConfig = ''
        # Audio output for PulseAudio/PipeWire
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }

        # Fallback to PulseAudio if PipeWire fails
        audio_output {
          type "pulse"
          name "PulseAudio Sound Server"
        }

        # Visualization output for ncmpcpp
        audio_output {
          type "fifo"
          name "Visualizer"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }

        # Auto update database when files change
        auto_update "yes"
        auto_update_depth "3"

        # ReplayGain
        replaygain "auto"
      '';
    };

    # Ensure playlist directory exists
    home.activation.createMpdPlaylistDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "${config.xdg.dataHome}/mpd/playlists"
    '';
  };
}
