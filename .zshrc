export ZSH=/home/loinguyen/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(
  git,
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/opt/idea-IC-181.4668.68/bin
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# User configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
export EDITOR='vim'
alias open="xdg-open"

export PYTHONPATH=/usr/local/lib/python3.5
export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=~/.virtualenvs
source $HOME/.local/bin/virtualenvwrapper.sh
