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
  set _output (ai -n --history --model=claude-3-5-haiku-latest "You are a terminal completion agent for a user using fish shell and kitty terminal. Your output should ONLY be a complete and valid terminal command, with no additional explanation, because the output will be substituted on the commandline of the active terminal window as input. Make sure your output is always a FULL shell command, not just the completion. Furthermore, input from the user might be a mix of a partial terminal command and plain human-readable explaining the user's intention. With these instructions in mind, return the most likely completion for the following partial input, which was already written by the user: $_input")

  commandline -r (echo $_output | string trim)
end


bind \e airun
bind -k btab aicomplete
