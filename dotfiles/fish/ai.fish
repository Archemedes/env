alias aigc 'git commit -m (ai --model=claude-3-5-haiku-latest -n "Generate a git semantic commit message from the following diff: $(git diff --cached HEAD | string escape)")'

function airun
  set _input (commandline | string trim)
  if test -n "$_input"

    test (string length "$_input") -lt 10 && return 

    set first_word (string split " " "$_input")[1]
    command -q "$first_word" && return

    set _input (echo $_input | string escape)
    commandline -r "ai -n $_input"
    commandline -f execute
  end
end

function aicomplete
  set _input (commandline | string trim | string escape)
  set _system_prompt (cat $__fish_config_dir/prompts/shell_completion)
  set _output (ai -n --history --model=claude-3-5-haiku-latest --system $_system_prompt "Return the most likely completion for the following partial input, which was already written by the user: $_input")

  commandline -r (echo $_output | string trim)
end


bind \e airun
bind -k btab aicomplete
