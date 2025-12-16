function doasedit --description "edit files as root using an unprivileged editor written by fish"

    function help --description "show help to stderr"
        printf '%s\n' \
                'doasedit-fs - FreeBSD doasedit, but written in fish' \
                '' \
                'usage: doasedit file...' \
                '       doasedit -h | -v' \
                '' \
                'Options:' \
                '  -h, --help     display help message and exit' \
                '  -v, --version  display version information and exit' \
                '  --             stop processing command line arguments' \
        >&2
    end

    function error --description "print error to stderr"
        printf 'doasedit: %s\n' $argv >&2
    end

    # Checks for syntax errors in doas' config
    function check_doas_conf
        set -l target      $argv[1]
        set -l tmp_target  $argv[2]

        if string match -rq '^/etc/doas(\.d/.*)?\.conf$' -- $target
            while not doas -C "$tmp_target"
                printf "doasedit: Replacing '%s' would " "$target"
                printf 'introduce the above error and break doas.\n'
                printf '(E)dit again, (O)verwrite anyway, (A)bort: [E/o/a]? '
                read -l choice
                switch $choice
                    case o O
                        return 0
                    case a A
                        return 1
                    case '*'
                        $editor_cmd "$tmp_target"
                end
            end
        end
        return 0
    end

    # --- argument parsing ---
    if test (count $argv) -eq 0
        help
        return 1
    end

    set -l args $argv
    while test (count $args) -gt 0
        switch $args[1]
            case --
                set -e args[1]
                break
            case -h --help
                help
                return 0
            case -v --version
                printf 'doasedit version 1.0.0\n'
                return 0
            case '-*'
                printf "doasedit: invalid option: '%s'\n" $args[1]
                help
                return 1
            case '*'
                break
        end
        set -e args[1]
    end

    if test (count $args) -eq 0
        help
        return 1
    end

    set -l user_id (id -u)
    if test "$user_id" -eq 0
        error "using this program as root is not permitted"
        return 1
    end

    # --- pick editor ---
    set -l editor_cmd
    if set -q DOAS_EDITOR; and test -n "$DOAS_EDITOR"
        set editor_cmd $DOAS_EDITOR
    else if set -q VISUAL; and test -n "$VISUAL"
        set editor_cmd $VISUAL
    else if set -q EDITOR; and test -n "$EDITOR"
        set editor_cmd $EDITOR
    else if type -q vi
        set editor_cmd vi
    else
        error 'no editor specified'
        return 1
    end

    if not type -q $editor_cmd[1]
        error "invalid editor command: '(string join ' ' $editor_cmd)'"
        return 1
    end

    set -g exit_code 1
    set -g tmpdir (mktemp -d -t doasedit-XXXXXX 2>/dev/null); or set -g tmpdir (mktemp -d)

    function __doasedit_cleanup
        if test -n "$tmpdir"; and test -d "$tmpdir"
            command rm -rf -- "$tmpdir"
        end
    end
    function __doasedit_on_exit --on-event fish_exit
        __doasedit_cleanup
    end
    function __doasedit_on_sigint --on-signal SIGINT;  __doasedit_cleanup; return 130; end
    function __doasedit_on_sighup --on-signal SIGHUP;  __doasedit_cleanup; return 130; end
    function __doasedit_on_sigquit --on-signal SIGQUIT; __doasedit_cleanup; return 130; end
    function __doasedit_on_sigterm --on-signal SIGTERM; __doasedit_cleanup; return 130; end
    function __doasedit_on_sigabrt --on-signal SIGABRT; __doasedit_cleanup; return 130; end

    # --- main loop ---
    for file in $args
        set -e exists
        set -e writable

        set -l base (basename -- "$file")
        set -l dir  (dirname  -- "$file")
        set -l tmpfile       "$tmpdir/$base"
        set -l tmpfile_copy  "$tmpdir/copy-of-$base"

        printf '' | tee -- "$tmpfile" > "$tmpfile_copy"
        chmod 0600 -- "$tmpfile" "$tmpfile_copy"

        if test -e "$file"
            if not test -f "$file"
                error "$file: not a regular file"
                continue
            end
            set -l owned_by_user (find "$file" -prune -user "$user_id" 2>/dev/null)
            if test -n "$owned_by_user"
                error "$file: editing your own files is not permitted"
                continue
            end
            set exists 1
        else if doas test -e -- "$file"
            if not doas test -f -- "$file"
                error "$file: not a regular file"
                continue
            end
            set exists 0
        else
            set -l dir_owned_by_user (find "$dir" -prune -user "$user_id" 2>/dev/null)
            if test -n "$dir_owned_by_user"
                error "$file: creating files in your own directory is not permitted"
                continue
            else if test -x "$dir"; and test -w "$dir"
                error "$file: creating files in a user-writable directory is not permitted"
                continue
            else if not doas test -e -- "$dir"
                error "$file: no such directory"
                continue
            end
        end

        if set -q exists
            if test -w "$file"
                set writable 1
            else if not doas dd status=none count=0 of=/dev/null
                error "unable to run 'doas dd'"
                continue
            end

            if test -r "$file"
                if set -q writable
                    error "$file: editing user-readable and -writable files is not permitted"
                    continue
                end
                cat -- "$file" > "$tmpfile"
            else if not doas cat -- "$file" > "$tmpfile"
                error "you are not permitted to call 'doas cat'"
                continue
            end
            cat -- "$tmpfile" > "$tmpfile_copy"
        end

        $editor_cmd "$tmpfile"

        if not check_doas_conf "$file" "$tmpfile"
            continue
        end

        if cmp -s -- "$tmpfile" "$tmpfile_copy"
            printf 'doasedit: %s: unchanged\n' "$file"
        else
            if set -q writable
                dd status=none if="$tmpfile" of="$file"
            else
                for de_tries in 2 1 0
                    if doas dd status=none if="$tmpfile" of="$file"
                        break
                    else if test $de_tries -eq 0
                        error '3 incorrect password attempts'
                        return 1
                    end
                end
            end
        end

        set exit_code 0
    end

    return $exit_code
end
