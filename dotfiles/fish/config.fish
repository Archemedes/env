if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

function fish_greeting
end

abbr -a gs git status
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a jl jupyter-lab
abbr -a pip. pip install -e .
abbr -a gco git checkout
abbr -a glog git log --no-decorate --oneline
abbr -a gp git pull
abbr -a yt ytfzf -md
abbr -a venv source .venv/bin/activate.fish
abbr -a penv "source (poetry env info --path)/bin/activate.fish"
abbr -a pr poetry run
abbr -a ji jira
abbr -a lzd lazydocker
abbr -a lzg lazygit
abbr -a u uv run

abbr -a awsaccounts 'aws organizations list-accounts --query "Accounts[*].[Name,Id]" --output table'
abbr -a awsinstances 'aws ec2 describe-instances --profile customer-zero --query "Reservations[*].Instances[0].[InstanceId,State.Name]"'

#cd commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd.="cd (readlink -f .)" #Switch symlink


# ls commands
if command -q eza
  alias ls eza
  alias lsdir "eza --only-dirs"
  alias ll "eza --long --icons=auto --color=auto"
end

function aka --argument-names new current
  alias $new=$current
  complete -c $new -w $current
end 

aka nv nvim
aka g git
aka k kubectl
aka py python

set -gx EDITOR nvim
set -gx EXA_STANDARD_OPTIONS --long --all --icons
set -gx fish_user_paths "$HOME/.local/bin"


source "$__fish_config_dir/kitty.fish"
source "$__fish_config_dir/ai.fish"

# Keeping project-specific setup I don't actually want in my dotfiles repo
if test -d "$__fish_config_dir/extra"
  for f in $__fish_config_dir/extra/*.fish
    source $f
  end
end


# fzf for selecting branches when we have a lot of branches
function gitbf
  set -l branches (git branch -a | string split0)
  echo $branches
  set -l branch (echo $branches | fzf +s +m -e)
  git checkout (echo $branch | sed "s:.* remotes/origin/::" | sed "s:.* ::")
end

starship init fish | source
zoxide init fish | source
