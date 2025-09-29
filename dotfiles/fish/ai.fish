# This makes ai commands not show up in history, which I think is correct
abbr ai " ai"

alias aigc 'git commit -m (ai --model=anthropic/claude-3-5-haiku-latest -n "Generate a git semantic commit message from the following diff: $(git diff --cached HEAD | string escape)")'

function airun
  set _input (commandline | string trim)
  if test -n "$_input"

    test (string length "$_input") -lt 10 && return 

    set first_word (string split " " "$_input")[1]
    command -q "$first_word" && return

    set _input (echo $_input | string escape)
    commandline -r " ai $_input"
    commandline -f execute
  end
end

function aicomplete
  set _input (commandline | string trim | string escape)
  set _output (ai -m anthropic/claude-3.5-haiku -n --history --system shell_completion "Return the most likely completion for the following partial input, which was already written by the user: $_input")

  commandline -r (echo $_output | string trim)
end

bind \ea airun
bind ctrl-tab aicomplete
