eval "$(/opt/homebrew/bin/brew shellenv)"

function fish_greeting
end

abbr -a gs git status
abbr -a gcm git commit -m 
abbr -a jl jupyter-lab
abbr -a pip. pip install -e .
abbr -a gco git checkout
abbr -a glog git log --no-decorate --oneline
abbr -a gp git pull
abbr -a yt ytfzf -md
abbr -a venv source .venv/bin/activate.fish
abbr -a psh poetry shell

abbr -a awsaccounts 'aws organizations list-accounts --query "Accounts[*].[Name,Id]" --output table'
abbr -a awsinstances 'aws ec2 describe-instances --profile customer-zero --query "Reservations[*].Instances[0].[InstanceId,State.Name]"'

#cd commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd.="cd (readlink -f .)" #Switch symlink

alias icat="kitty +kitten icat"
alias penv "source (poetry env info --path)/bin/activate.fish"

function aka --argument-names new current
  alias $new=$current
  complete -c $new -w $current
end 

aka nv nvim
aka g git
aka k kubectl
aka py python

set -gx TERM xterm-kitty
set -gx EXA_STANDARD_OPTIONS --long --all --icons
set -gx fish_user_paths "$HOME/.local/bin"

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

# push a tag with certain name even if it already exists
function gtag
    set -l tagname $argv[1]
    git tag --delete $tagname
    git push --delete origin $tagname
    git tag $tagname
    git push origin $tagname
end

starship init fish | source
zoxide init fish | source
