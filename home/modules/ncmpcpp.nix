{
  config,
  lib,
  ...
}: let
  cfg = config.my.hm.ncmpcpp;
in {
  options.my.hm.ncmpcpp = {
    enable = lib.mkEnableOption "Enable ncmpcpp music player";
  };

  config = lib.mkIf cfg.enable {
    programs.ncmpcpp = {
      enable = true;

      settings = {
        # MPD Connection
        mpd_host = "127.0.0.1";
        mpd_port = 6600;
        mpd_connection_timeout = 5;
        mpd_crossfade_time = 3;

        # Visualizer
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "Visualizer";
        visualizer_in_stereo = "yes";
        visualizer_type = "spectrum";
        visualizer_look = "●▮";
        visualizer_color = "blue, cyan, green, yellow, magenta, red";
        visualizer_spectrum_smooth_look = "yes";

        # Display
        song_list_format = "{$4%a - }{%t}|{$8%f$9}$R{$3(%l)$9}";
        song_status_format = "$b{{$8%t}} $3by {$4%a}{ $3in $7%b}|{$8%f}";
        song_library_format = "{%n - }{%t}|{%f}";
        alternative_header_first_line_format = "$b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b";
        alternative_header_second_line_format = "{{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}";
        current_item_prefix = "$(cyan)$r$b";
        current_item_suffix = "$/r$(end)$/b";
        current_item_inactive_column_prefix = "$(magenta)$r";
        current_item_inactive_column_suffix = "$/r$(end)";
        now_playing_prefix = "$b";
        now_playing_suffix = "$/b";
        browser_playlist_prefix = "$2playlist$9 ";
        selected_item_prefix = "$6";
        selected_item_suffix = "$9";
        modified_item_prefix = "$3> $9";

        # Progress Bar
        progressbar_look = "━━─";
        progressbar_color = "black:b";
        progressbar_elapsed_color = "blue:b";

        # UI
        user_interface = "alternative";
        playlist_display_mode = "columns";
        browser_display_mode = "columns";
        search_engine_display_mode = "columns";
        playlist_editor_display_mode = "columns";
        autocenter_mode = "yes";
        centered_cursor = "yes";
        statusbar_visibility = "yes";
        titles_visibility = "yes";
        header_visibility = "yes";
        enable_window_title = "yes";
        statusbar_color = "default";
        color1 = "white";
        color2 = "green";
        volume_color = "default";
        state_line_color = "default";
        state_flags_color = "default:b";
        main_window_color = "yellow";
        header_window_color = "default";
        alternative_ui_separator_color = "black:b";
        window_border_color = "green";
        active_window_border = "red";

        # Mouse
        mouse_support = "yes";
        mouse_list_scroll_whole_page = "no";

        # Other
        lyrics_fetchers = "azlyrics, genius, musixmatch, sing365, metrolyrics, justsomelyrics, jahlyrics, plyrics, tekstowo, zeneszoveg, internet";
        follow_now_playing_lyrics = "yes";
        fetch_lyrics_for_current_song_in_background = "yes";
        store_lyrics_in_song_dir = "no";
        generate_win32_compatible_filenames = "yes";
        allow_for_physical_item_deletion = "no";
        show_hidden_files_in_local_browser = "no";
        screen_switcher_mode = "playlist, media_library";
        startup_screen = "playlist";
        startup_slave_screen = "";
        startup_slave_screen_focus = "no";
        locked_screen_width_part = 50;
        ask_for_locked_screen_width_part = "yes";
        jump_to_now_playing_song_at_start = "yes";
        ask_before_clearing_playlists = "yes";
        clock_display_seconds = "no";
        display_volume_level = "yes";
        display_bitrate = "yes";
        display_remaining_time = "no";
        ignore_leading_the = "yes";
        ignore_diacritics = "yes";
        block_search_constraints_change_if_items_found = "yes";
        media_library_primary_tag = "artist";
        media_library_albums_split_by_date = "yes";
        media_library_hide_album_dates = "no";
        default_find_mode = "wrapped";
        default_place_to_search_in = "database";
        data_fetching_delay = "yes";
        message_delay_time = 5;
        connected_message_on_startup = "yes";
        execute_on_song_change = "";
        execute_on_player_state_change = "";
        empty_tag_marker = "<empty>";
        tags_separator = " | ";
        tag_editor_extended_numeration = "no";
        media_library_sort_by_mtime = "no";
        external_editor = "nvim";
        use_console_editor = "yes";
        cyclic_scrolling = "no";
        lines_scrolled = 2;
        search_engine_default_search_mode = 1;
        space_add_mode = "add_remove";
        default_tag_editor_pattern = "%n - %t";
        playlist_show_mpd_host = "no";
        playlist_show_remaining_time = "no";
        playlist_shorten_total_times = "no";
        playlist_separate_albums = "no";
        playlist_disable_highlight_delay = 5;
        regular_expressions = "perl";
        incremental_seeking = "yes";
        seek_time = 1;
        volume_change_step = 2;
        lastfm_preferred_language = "en";
        discard_colors_if_item_is_selected = "yes";
        show_duplicate_tags = "yes";
      };

      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "J"; command = [ "select_item" "scroll_down" ]; }
        { key = "K"; command = [ "select_item" "scroll_up" ]; }
        { key = "h"; command = "previous_column"; }
        { key = "l"; command = "next_column"; }
        { key = "g"; command = "move_home"; }
        { key = "G"; command = "move_end"; }
        { key = "n"; command = "next_found_item"; }
        { key = "N"; command = "previous_found_item"; }
        { key = "."; command = "show_lyrics"; }
        { key = "x"; command = "delete_playlist_items"; }
        { key = "U"; command = "update_database"; }
      ];
    };
  };
}
