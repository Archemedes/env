# Taken from https://github.com/nickeb96/puffer-fish
# Just the stuff I need, not the stuff I don't
status is-interactive || exit

function _puffer_fish_expand_dots -d 'expand ... to ../.. etc'
    set -l cmd (commandline --cut-at-cursor)
    set -l split (string split -- ' ' $cmd)
    if string match --quiet --regex -- '^(\.\./)*\.\.$' $split[-1]
        commandline --insert '/..'
    else
        commandline --insert '.'
    end
end

function _puffer_fish_expand_bang
    switch (commandline -t)
      case '!'
        commandline -t $history[1]
      case '*'
        commandline -i '!'
    end
end


bind . _puffer_fish_expand_dots
bind ! _puffer_fish_expand_bang
