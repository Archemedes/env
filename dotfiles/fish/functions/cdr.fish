function cdr
    set -l markers .git README.md README README.rst package.json pyproject.toml Cargo.toml go.mod Makefile Gemfile
    set -l dir (pwd)
    while test $dir != /
        for m in $markers
            if test -e $dir/$m
                cd $dir
                commandline -f repaint
                return
            end
        end
        set dir (dirname $dir)
    end
    echo "No project root detected." >&2
end
