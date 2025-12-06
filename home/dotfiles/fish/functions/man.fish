set -gx BAT_THEME "Catppuccin Latte"
set -gx BAT_STYLE plain

function man --wraps man --description 'Display man pages with bat'
    set -lx MANPAGER "sh -c 'col -bx | bat -l man -p --paging=always'"
    set -lx MANROFFOPT "-c"
    
    set -lx MANPATH (string join : $MANPATH)
    if test -z "$MANPATH"
        type -q manpath; and set MANPATH (command manpath)
    end
    
    set -l fish_data_dir
    if set -q __fish_data_dir
        set fish_data_dir $__fish_data_dir
    else
        set fish_data_dir $__fish_datadir
    end
    
    set -l fish_manpath (dirname $fish_data_dir)/fish/man
    if test -d "$fish_manpath" -a -n "$MANPATH"
        set MANPATH "$fish_manpath":$MANPATH
    end
    
    command man $argv
end
