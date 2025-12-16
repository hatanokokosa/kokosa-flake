# MIT License

# Copyright (c) 2016 Francisco Lourenço & Daniel Wehner

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if not status is-interactive
    exit
end

set -g __done_version 1.20.0

function __done_run_powershell_script
    set -l powershell_exe (command --search "powershell.exe")

    if test $status -ne 0
        and command --search wslvar

        set -l powershell_exe (wslpath (wslvar windir)/System32/WindowsPowerShell/v1.0/powershell.exe)
    end

    if string length --quiet "$powershell_exe"
        and test -x "$powershell_exe"

        set cmd (string escape $argv)

        eval "$powershell_exe -Command $cmd"
    end
end

function __done_windows_notification -a title -a message
    if test "$__done_notify_sound" -eq 1
        set soundopt "<audio silent=\"false\" src=\"ms-winsoundevent:Notification.Default\" />"
    else
        set soundopt "<audio silent=\"true\" />"
    end

    __done_run_powershell_script "
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null

\$toast_xml_source = @\"
    <toast>
        $soundopt
        <visual>
            <binding template=\"ToastText02\">
                <text id=\"1\">$title</text>
                <text id=\"2\">$message</text>
            </binding>
        </visual>
    </toast>
\"@

\$toast_xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$toast_xml.loadXml(\$toast_xml_source)

\$toast = New-Object Windows.UI.Notifications.ToastNotification \$toast_xml

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\"fish\").Show(\$toast)
"
end

function __done_get_focused_window_id
    if type -q lsappinfo
        lsappinfo info -only bundleID (lsappinfo front | string replace 'ASN:0x0-' '0x') | cut -d '"' -f4
    else if test -n "$SWAYSOCK"
        and type -q jq
        swaymsg --type get_tree | jq '.. | objects | select(.focused == true) | .id'
    else if test -n "$HYPRLAND_INSTANCE_SIGNATURE"
        hyprctl activewindow | awk 'NR==1 {print $2}'
    else if type -q xdotool
        and xdotool getwindowfocus >/dev/null
        xdotool getwindowfocus
    else if type -q tmux
        and test $TMUX (command tmux display-message -p '#{pane_id}')
        command tmux display-message -p '#{pane_id}'
    else if type -q kitty
        and kitty @ ls >/dev/null
        kitty @ ls | jq '.. | .id? | select (. != null)'
    end
end

function __done_notification
    set -l title $argv[1]
    set -l message $argv[2]

    if test -n "$__done_notification_command"
        if string match -e '%s' $__done_notification_command >/dev/null
            set message (string replace '%s' "$message" $__done_notification_command)
            eval "$message"
        else
            eval "$__done_notification_command"
        end
        return
    end

    switch (uname)
        case Darwin
            command osascript -e "display notification \"''$message''\" with title \"''$title''\""
        case Linux FreeBSD NetBSD DragonFly
            if string match -q "*tmux*" "$TERM"
                __done_tmux_silence "$title" "$message"
            else if set -q DISPLAY
                and type -q gdbus
                and begin
                    if type -q swaymsg
                        command swaymsg --quiet --type get_outputs >/dev/null
                    else
                        true
                    end
                end
                    gdbus call \
                        --session \
                        --dest org.freedesktop.Notifications \
                        --object-path /org/freedesktop/Notifications \
                        --method org.freedesktop.Notifications.Notify \
                        "fish" \
                        0 \
                        "" \
                        "$title" \
                        "$message" \
                        [] \
                        {} \
                        -1 \
                        >/dev/null
            else if type -q terminal-notifier
                command terminal-notifier -title "$title" -message "$message"
            else if type -q tmux
                __done_tmux_silence "$title" "$message"
            else if type -q notify-send
                command notify-send "$title" "$message"
            end
        case MINGW* MSYS*
            __done_windows_notification "$title" "$message"
    end
end

function __done_is_tmux_focused
    if not string match -q "*tmux*" "$TERM"
        return 1
    end

    set -q TMUX || return 1

    set -l focused_window_id (__done_get_focused_window_id)
    set -l tmux_window_id (command tmux display-message -p '#{pane_id}')

    test "$focused_window_id" = "$tmux_window_id"
end

function __done_tmux_silence
    if not set -q __done_show_in_tmux
        or __done_is_tmux_focused
        return
    end

    command tmux display-message "✔ $argv[1] $argv[2]"
end

function __done_is_screen_locked
    switch (uname)
        case Darwin
            if not type -q python3
                return 1
            end

            python3 (status --current-filename | xargs dirname)/done/is-screen-locked
        case Linux
            if test -n "$SWAYSOCK"
                swaymsg --quiet --type get_tree | jq --exit-status 'any(.. | objects | select(.type? == "workspace"); (.visible? == true and .focused? == true))'
            else if test -n "$HYPRLAND_INSTANCE_SIGNATURE"
                hyprctl -j monitors | jq --exit-status 'map(.focused)' \
                    && hyprctl -j activewindow | jq --exit-status '.initialClass != "kitty"'
            else if set -q DISPLAY
                if type -q gdbus \
                        && gdbus call --timeout=1 --session --dest org.gnome.ScreenSaver \
                            --object-path /org/gnome/ScreenSaver \
                            --method org.gnome.ScreenSaver.GetActive \
                        >/dev/null
                    return $status
                else if type -q qdbus \
                        && qdbus org.freedesktop.ScreenSaver \
                            /ScreenSaver org.freedesktop.ScreenSaver.GetActive \
                        >/dev/null
                    return $status
                else if type -q xssstate
                    command xssstate -s | string match --quiet --regex '^(locked|disabled)$'
                else if type -q xscreensaver-command \
                        && command xscreensaver-command -time \
                        | string match --quiet --regex '.*screen locked.*'
                    return $status
                end
            end
        case FreeBSD NetBSD DragonFly
            if set -q DISPLAY
                if type -q xscreensaver-command \
                        && command xscreensaver-command -time \
                        | string match --quiet --regex '.*screen locked.*'
                    return $status
                end
            end
        case MINGW* MSYS*
            powershell.exe -Command "[Environment]::GetEnvironmentVariable(\"SCREENSAVERRUNNING\", \"HKCU\")"
    end
end

function __done_windows_terminal
    test -n "$WT_SESSION" || return 1

    # There is no direct way to query the window title, so use heuristics to match.
    # 1. ignore when window is zoomed in
    # 2. remove known suffixes for consistency
    # 3. normalise spaces
    # 4. ignore any extra text outside the main highlight
    # See https://github.com/jorgebucaran/hydro for the original implementation
    set title (
        command pwsh.exe -NoLogo -NoProfile -Command '
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $windows = [System.Windows.Forms.Application]::OpenForms
        foreach ($window in $windows) {
            if ($window.Name -ne "Win32Window") { continue }
            if (!$window.Visible) { continue }
            $bounds = $window.RestoreBounds
            if ($bounds.IsEmpty) { continue }
            if ($window.Tag -notlike "*Windows.Terminal*") { continue }
            return $window.Text
        }
        ' 2>/dev/null | string trim --right --chars "="
    )

    if test -z "$title"
        return 1
    end

    set focused_title (
        command pwsh.exe -NoLogo -NoProfile -Command '
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $point = [System.Windows.Forms.Control]::MousePosition

        $windows = [System.Windows.Forms.Application]::OpenForms
        foreach ($window in $windows) {
            if ($window.Name -ne "Win32Window") { continue }
            if (!$window.Visible) { continue }
            $bounds = $window.RestoreBounds
            if ($bounds.IsEmpty) { continue }
            if ($window.Tag -notlike "*Windows.Terminal*") { continue }
            if (!$bounds.Contains($point)) { continue }
            return $window.Text
        }
        ' 2>/dev/null | string trim --right --chars "="
    )

    if test "$title" = "$focused_title"
        return 0
    end

    return 1
end

function __done_notification_terminology -a title -a message
    if test (string length $title) -gt 0
        set message (printf "%s\n%s" $title $message)
    end

    command echo -en "\e]777;notify;$message\e\\" >/dev/tty
end

function __done_is_first_notification
    set -q __done_notified_last_command || return 0

    return 1
end

function __done_allow_on_notification_context
    if __done_is_first_notification
        return 0
    end

    switch "$__done_allow_on_notification"
        case 'always'
            return 0
        case 'command_day'
            set -l last_cmd_date (string split ' ' $__done_notified_last_command)[1]
            if test "$last_cmd_date" = (date '+%F')
                return 0
            end
        case 'command_session'
            set -l last_cmd_session (string split ' ' $__done_notified_last_command)[3]
            if test "$last_cmd_session" = "$fish_pid"
                return 0
            end
    end

    return 1
end

function __done_is_context_allowed -a command
    if __done_allow_on_notification_context
        return 0
    end

    switch "$__done_when"
        case 'any'
            return 0
        case 'command'
            set -q command[1] && return 0
        case 'pane'
            if not string match -q "*tmux*" "$TERM"
                return 1
            end

            if test (command tmux display-message -p '#{pane_id}') = $TMUX_PANE
                return 0
            end
        case 'user'
            if test (id -un) = $USER
                return 0
            end
    end

    return 1
end

function __done_is_duration_allowed -a duration
    switch "$__done_min_cmd_duration"
        case always
            return 0
        case never
            return 1
        case '*'
            if test $duration -ge $__done_min_cmd_duration
                return 0
            end
    end

    return 1
end

function __done_is_sleeping_allowed
    if not set -q __done_allow_when_idle
        return 0
    end

    switch $__done_allow_when_idle
        case 'any'
            return 0
        case 'focused'
            if __done_is_tmux_focused
                or __done_windows_terminal
                return 0
            end
        case 'unfocused'
            if not __done_is_tmux_focused
                and not __done_windows_terminal
                return 0
            end
    end

    return 1
end

function __done_increment_command_counter
    if not set -q __done_notification_counter
        set -g __done_notification_counter 0
    end

    set -g __done_notification_counter (math $__done_notification_counter + 1)
end

function __done__notify -a command -a duration -a exit_code
    # Windows Notification
    if string match -q 'Windows*' (uname -a)
        set command (string replace -a -- ';' ',' $command)
    end

    set -l user (id -un)
    set -l hostname (hostname -s)
    set -l message "cmd: $command"
    set -l title ""

    if test $exit_code -ne 0
        set title (printf "✖ \"%s\" failed in %s" "$command" "$duration")
    else
        set title (printf "✔ \"%s\" finished in %s" "$command" "$duration")
    end

    if test "$__done_notify_last_command" = 0
        set message "$message\nstatus: $exit_code"
    end

    if test "$__done_notify_user_hostname" = 1
        set message "$message\nuser: $user@$hostname"
    end

    if set -q __done_title_additions
        if test (count $__done_title_additions) -gt 0
            set -l joined (string join ', ' $__done_title_additions)
            set title "$title ($joined)"
        end
    end

    switch "$__done_notification_type"
        case 'balloon'
            __done_notification "$title" "$message"
        case 'term'
            __done_notification_terminology "$title" "$message"
    end
end

function __done_reset_notifications
    set -e __done_notified_last_command
end

function __done_set_last_command --argument command exit_code duration
    set -g __done_duration_last_cmd $duration
    set -g __done_notified_last_command (date '+%F %T'):$fish_pid:$command
    set -g __done_last_exit_status $exit_code
end

function __done_should_notify
    set -l duration $__done_duration_last_cmd
    set -l exit_code $__done_last_exit_status

    test "$__done_only_when" = "failed" && test $__done_last_exit_status = 0 && return 1

    if set -q __done_allow_when_idle
        if not test $__done_allow_when_idle = "any"
            if __done_is_sleeping_allowed
                return 1
            end
        end
    else
        if not __done_is_tmux_focused
            and not __done_windows_terminal
            and __done_is_sleeping_allowed
            return 1
        end
    end

    test "$__done_when" = "command" || return 1
    test "$__done_notify_active_only" = 1 && __done_is_screen_locked && return 1
    return 0
end

function __done_notification_handler
    set -l state $argv[1]

    switch "$state"
        case 'begin'
            set -g __done_time_start (command date +%s%3N)
            test $status -ne 0 && return 1
        case 'end'
            set -l duration_ms (math (command date +%s%3N) - $__done_time_start)
            set -l duration (__done_format_time $duration_ms)

            set -l command (commandline -p)
            set -l exit_code $argv[2]

            set -l should_notify 0
            set -l notification_type $__done_notification_type

            # Determine if a notification should be shown
            if not __done_is_duration_allowed $duration_ms \
                    || not __done_is_context_allowed $command \
                    || not set -q command[1]
                set should_notify 1
            end

            if test $should_notify -eq 0
                if __done_is_sleeping_allowed
                    set should_notify 1
                else if not __done_is_tmux_focused
                    or not __done_windows_terminal
                    set should_notify 1
                end
            end

            set -g __done_duration_last_cmd $duration
            set -g __done_last_exit_status $exit_code

            if test $should_notify -eq 0
                set -g __done_last_command $command
            end

            set -g __done_last_notification_time (command date +%s)

            if test $should_notify -eq 1
                __done_reset_notifications
                return
            end

            __done_set_last_command $command $exit_code $duration
            __done_increment_command_counter

            if not __done_should_notify
                return
            end

            if test "$notification_type" = 'term'
                # Output to terminal instead of notification bubble
                __done_notification_terminology "✔ $command" "exit $exit_code, $duration"
            else
                __done__notify $command $duration $exit_code
            end
    end
end

function __done_init
    set -g __done_when (commandline --paging-mode; and echo command; or echo any)
    set -g __done_notification_type (set -q __done_notification_type; and echo $__done_notification_type; or echo balloon)
    set -g __done_notify_active_only (set -q __done_notify_active_only; and echo $__done_notify_active_only; or echo 1)
    set -g __done_min_cmd_duration (set -q __done_min_cmd_duration; and echo $__done_min_cmd_duration; or echo 10000)
    set -g __done_notify_last_command (set -q __done_notify_last_command; and echo $__done_notify_last_command; or echo 0)
    set -g __done_notification_command (set -q __done_notification_command; and echo $__done_notification_command; or echo "")
    set -g __done_notify_sound (set -q __done_notify_sound; and echo $__done_notify_sound; or echo 1)
    set -g __done_allow_when_idle (set -q __done_allow_when_idle; and echo $__done_allow_when_idle; or echo "")
    set -g __done_allow_on_notification (set -q __done_allow_on_notification; and echo $__done_allow_on_notification; or echo "never")
    set -g __done_only_when (set -q __done_only_when; and echo $__done_only_when; or echo "always")

    function __done_wrapper_begin --on-event fish_preexec --description "done notification wrapper"
        __done_notification_handler begin
    end

    function __done_wrapper_end --on-event fish_postexec --description "done notification wrapper"
        __done_notification_handler end $status
    end
end

function __done_format_time -a ms

    set -l total_ms (math --scale 0 "round($ms)")
    set -l sec (math --scale 0 "$total_ms / 1000")
    set -l min (math --scale 0 "$sec / 60")
    set -l hr  (math --scale 0 "$min / 60")
    set -l day (math --scale 0 "$hr / 24")

    if test $day -gt 0
        printf "%dd %dh %dm %ds" \
            $day \
            (math --scale 0 "$hr % 24") \
            (math --scale 0 "$min % 60") \
            (math --scale 0 "$sec % 60")
    else if test $hr -gt 0
        printf "%dh %dm %ds" \
            $hr \
            (math --scale 0 "$min % 60") \
            (math --scale 0 "$sec % 60")
    else if test $min -gt 0
        printf "%dm %ds" \
            $min \
            (math --scale 0 "$sec % 60")
    else
        printf "%d.%03ds" \
            $sec \
            (math --scale 0 "$total_ms % 1000")
    end
end

__done_init
