if status is-interactive
    # Commands to run in interactive sessions can go here
    if type -q pyenv
        pyenv init - | source
        pyenv virtualenv-init - | source
    end
end

function fish_greeting
    echo ''
end

abbr -a gs git status
abbr -a jl jupyter-lab
abbr -a pyv pyenv activate
abbr -a pip. pip install -e .
abbr -a gco git checkout
abbr -a glog git log --no-decorate --oneline
abbr -a gp git pull
abbr -a yt ytfzf -md

abbr -a awsaccounts 'aws organizations list-accounts --query "Accounts[*].[Name,Id]" --output table'
abbr -a awsinstances 'aws ec2 describe-instances --profile customer-zero --query "Reservations[*].Instances[0].[InstanceId,State.Name]"'

#cd commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd.="cd (readlink -f .)" #Switch symlink

alias icat="kitty +kitten icat"

function aka --argument-names new current
  alias $new=$current
  complete -c $new -w $current
end 

aka nv nvim
aka g git
aka fd fdfind

set -gx PATH $HOME/.pyenv/bin $HOME/.local/bin $PATH
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PYENV_VIRTUALENV_DISABLE_PROMPT 1
set -gx EXA_STANDARD_OPTIONS --long --all --icons

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
