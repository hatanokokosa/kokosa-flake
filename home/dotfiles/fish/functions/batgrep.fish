function batgrep --description "Quickly search through and highlight files using ripgrep"
    # Default Options
    set -l ripgrep_cmd rg
    set -l rg_args
    set -l bat_args
    set -l pattern ""
    set -l files
    set -l case_sensitivity ""
    set -l context_before 2
    set -l context_after 2
    set -l follow true
    set -l snip ",snip"
    set -l highlight true
    set -l search_pattern false
    set -l fixed_strings false
    set -l no_separator false
    set -l bat_style "header,numbers"
    set -l pager_args
    set -l color_arg "--color=auto"

    # Check Bat Version
    if command -q bat
        set -l bat_ver (bat --version | string match -r '\d+\.\d+' | head -n1)
        if test (string split '.' $bat_ver)[2] -lt 12
            set snip ""
        end
    end

    # Parse Arguments
    set -l state "options"
    for arg in $argv
        switch $state
            case "options"
                switch $arg
                    # Ripgrep Options
                    case -i --ignore-case
                        set case_sensitivity "--ignore-case"
                    case -s --case-sensitive
                        set case_sensitivity "--case-sensitive"
                    case -S --smart-case
                        set case_sensitivity "--smart-case"

                    case -A --after-context
                        set state "after-context"
                    case -B --before-context
                        set state "before-context"
                    case -C --context
                        set state "context"

                    case -F --fixed-strings
                        set fixed_strings true
                        set rg_args $rg_args $arg

                    case -U --multiline -P --pcre2 -z --search-zip -w --word-regexp \
                         --one-file-system --multiline-dotall --ignore --no-ignore \
                         --crlf --no-crlf --hidden --no-hidden
                        set rg_args $rg_args $arg

                    case -E --encoding -g --glob -t --type -T --type-not \
                         -m --max-count --max-depth --iglob --ignore-file
                        set state "rg-value"
                        set last_opt $arg

                    case -u -uu -uuu
                        set rg_args $rg_args $arg
                    case --unrestricted
                        set rg_args $rg_args $arg

                    # Batgrep Specific Options
                    case --no-follow
                        set follow false
                    case --no-snip
                        set snip ""
                    case --no-highlight
                        set highlight false
                    case -p --search-pattern
                        set search_pattern true
                    case --no-search-pattern
                        set search_pattern false
                    case --no-separator
                        set no_separator true

                    case --rga
                        if not command -q rga
                            echo "batgrep: option '--rga' requires ripgrep-all to be installed" >&2
                            return 1
                        end
                        set ripgrep_cmd rga

                    case --color
                        set color_arg "--color=always"
                    case --no-color
                        set color_arg "--color=never"

                    case --paging
                        set state "paging"
                    case --pager
                        set state "pager-cmd"
                    case --terminal-width
                        set state "term-width"

                    case -h --help
                        _batgrep_help
                        return 0

                    case --
                        set state "files"

                    case '-*'
                        echo "batgrep: unknown option '$arg'" >&2
                        return 1

                    case '*'
                        if test -z "$pattern"
                            set pattern "$arg"
                        else
                            set files $files $arg
                        end
                end

            case "after-context"
                set context_after $arg
                set state "options"
            case "before-context"
                set context_before $arg
                set state "options"
            case "context"
                set context_before $arg
                set context_after $arg
                set state "options"
            case "rg-value"
                set rg_args $rg_args $last_opt $arg
                set state "options"
            case "files"
                set files $files $arg
        end
    end

    # Validate Pattern
    if test -z "$pattern"
        echo "batgrep: no pattern provided" >&2
        return 1
    end

    # Add Case Sensitivity
    if test -n "$case_sensitivity"
        set rg_args $rg_args $case_sensitivity
    end

    # Add Follow Option
    if test "$follow" = true
        set rg_args $rg_args --follow
    end

    # Add Color Option
    set bat_args $bat_args $color_arg

    # Disable Snip And Highlight
    if test $context_before -eq 0 -a $context_after -eq 0
        set snip ""
        set highlight false
    end

    # Handle Search Pattern Option
    if test "$search_pattern" = true
        set -l pager_cmd (set -q PAGER; and echo $PAGER; or echo "less")
        if string match -q "*less*" $pager_cmd
            if test "$fixed_strings" = true
                set pager_args -p (printf '\x12%s' "$pattern")
            else
                set pager_args -p "$pattern"
            end
        end
    end

    # Generate Separator
    set -l term_width (tput cols 2>/dev/null; or echo 80)
    set -l sep (string repeat -n $term_width "─")

    # Check Stdin Input
    set -l read_stdin false
    set -l stdin_data ""
    if not isatty stdin; and test (count $files) -eq 0
        set read_stdin true
        set stdin_data (cat)
    end

    # Ripgrep Search
    set -l rg_output
    if test "$read_stdin" = true
        set rg_output (echo $stdin_data | $ripgrep_cmd --with-filename --vimgrep $rg_args --context 0 --sort path -- "$pattern")
    else
        set rg_output ($ripgrep_cmd --with-filename --vimgrep $rg_args --context 0 --sort path -- "$pattern" $files)
    end

    set -l found 0
    set -l last_file ""
    set -l line_ranges
    set -l highlights

    # Process Results
    for line in $rg_output
        set found (math $found + 1)

        set -l parts (string split -m 3 ':' $line)
        set -l file $parts[1]
        set -l line_num $parts[2]
        set -l col $parts[3]

        if test "$last_file" != "$file"
            # Print Previous File
            if test -n "$last_file"
                _batgrep_print $last_file $line_ranges $highlights $bat_args $bat_style $snip $no_separator $sep $read_stdin "$stdin_data"
            end

            set last_file $file
            set line_ranges
            set highlights
        end

        # Calculate Context Lines
        set -l line_start (math $line_num - $context_before)
        set -l line_end (math $line_num + $context_after)
        test $line_start -lt 1; and set line_start 1

        set line_ranges $line_ranges "--line-range=$line_start:$line_end"
        if test "$highlight" = true
            set highlights $highlights "--highlight-line=$line_num"
        end
    end

    # Print Last File
    if test -n "$last_file"
        _batgrep_print $last_file $line_ranges $highlights $bat_args $bat_style $snip $no_separator $sep $read_stdin "$stdin_data"
    end

    # Exit Status
    if test $found -eq 0
        return 2
    end
end

function _batgrep_print
    set -l file $argv[1]
    set -l ranges
    set -l highlights
    set -l bat_args
    set -l bat_style
    set -l snip
    set -l no_separator
    set -l sep
    set -l read_stdin
    set -l stdin_data

    # Parse Print Arguments
    set -l i 2
    while test $i -le (count $argv)
        if string match -q -- '--line-range=*' $argv[$i]
            set ranges $ranges $argv[$i]
        else if string match -q -- '--highlight-line=*' $argv[$i]
            set highlights $highlights $argv[$i]
        else if string match -q -- '--color=*' $argv[$i]
            set bat_args $bat_args $argv[$i]
        else
            break
        end
        set i (math $i + 1)
    end

    # Extract Remaining Arguments
    set bat_style $argv[$i]
    set snip $argv[(math $i + 1)]
    set no_separator $argv[(math $i + 2)]
    set sep $argv[(math $i + 3)]
    set read_stdin $argv[(math $i + 4)]
    set stdin_data $argv[(math $i + 5)]

    # Print Separator
    if test "$no_separator" != true
        echo $sep
    end

    # Print File
    if test "$file" = "<stdin>"
        echo $stdin_data | bat $bat_args $ranges $highlights --style="$bat_style$snip" --paging=never -
    else
        bat $bat_args $ranges $highlights --style="$bat_style$snip" --paging=never "$file"
    end

    # Print Separator
    if test "$no_separator" != true
        echo $sep
    end
end

function _batgrep_help
    echo "Quickly search through and highlight files using ripgrep.

Usage: batgrep [OPTIONS] PATTERN [PATH...]

Arguments:
  PATTERN       Pattern passed to ripgrep
  [PATH...]     Path(s) to search

Options:
  -i, --ignore-case           Use case insensitive searching
  -s, --case-sensitive        Use case sensitive searching
  -S, --smart-case            Use smart case searching
  -A, --after-context LINES   Display the next n lines after a matched line
  -B, --before-context LINES  Display the previous n lines before a matched line
  -C, --context LINES         Combination of --after-context and --before-context
  -p, --search-pattern        Tell pager to search for PATTERN
  --no-follow                 Do not follow symlinks
  --no-snip                   Do not show the snip decoration
  --no-highlight              Do not highlight matching lines
  --color                     Force color output
  --no-color                  Force disable color output
  --no-separator              Disable printing separator between files
  --rga                       Use ripgrep-all instead of ripgrep
  -F, --fixed-strings         Treat pattern as literal string
  -h, --help                  Show this help" | bat -l help --style=plain
end
