alias aigc 'git commit -m (ai --model=claude-3-5-haiku-latest -n "Generate a git semantic commit message from the following diff: $(git diff --cached HEAD | string escape)")'
