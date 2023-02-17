alias vi='nvim'
alias vim='nvim'

# List files and folders
alias ls='exa -F'
alias l='exa -FGhl --git'
alias ltree='exa -FThl --git'
alias tree='exa -FT'

# CD commads
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# kubectl
alias k=kubectl

#color cat
alias cat="bat "

#copy to clipboard
alias copy='xclip -se c'

# gradle aliases
alias build='./gradlew clean build'
alias W='./gradlew '

# Pretty path display
alias path='echo $PATH | tr -s ":" "\n"'

# map input for piped command
alias map="xargs -n1"

alias goland='open -na "GoLand.app" --args "$@"'