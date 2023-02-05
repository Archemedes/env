function fish_greeting
    echo 'Success!'
end

#cd commands
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd.="cd (readlink -f .)" #Switch symlink
