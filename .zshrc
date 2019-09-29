export ZSH="/home/loi/.oh-my-zsh"

ZSH_THEME="bira"
DEFAULT_USER="loi"
plugins=(
  git command-not-found extract git-extras history-substring-search zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/loi/vexere/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/home/loi/vexere/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/loi/vexere/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/loi/vexere/tools/google-cloud-sdk/completion.zsh.inc'; fi

export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
source ~/vxr-gcloud-common-alias

alias help='tldr'

alias k9='k9s'
alias todo='todoist'
alias tdl='todoist list'
# Starter pack of aliases
#
# Edit your `$HOME/.bash_profile` file, and add
# these at the end.

# Show a full directory listing, marking files
# as their type
alias ll='ls -alF'

# Save time typing out `git status`
alias gs='git status'

# Shorten the git dance to `gacp 'Commit Message'`
gacp() {
  git add --all -v
  git commit -m "$1"
  git push -u origin HEAD
}

# If you are in git-bash on Windows, you might want this one:
alias more=less

## Some basic aliases:
# make standard file manipulation commands verbose
alias work='cd /home/loi/vexere && vim'
alias mv='mv -v'
alias cp='cp -v'
alias rm='rm -v'
alias tac="tail -r "


alias now='date "+%T"'

# This one works on Linux
alias ports='netstat -tulanp'

# These work on macOS
alias openip='lsof -Pnl +M' # open IP connections (4 or 6)
alias openip4='lsof -Pnl +M -i4' # open IPv4 connections
alias openip6='lsof -Pnl +M -i6' # open IPv6 connections

alias ping1='ping -c 1'
alias timestamp='date "+%Y-%m-%d-%H-%M-%S"'

alias s3sync='s3cmd -r --rexclude-from=$HOME/.s3sync-excludes sync '

function tree () {
  /bin/ls -AR | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# replace spaces in file names with underscores
function unspace_filename () {
  echo "$1" | tr --squeeze-repeats " " "_"
}

# lowercase file names
function lc_filename () {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

# clean file name: lower case, no spaces, alphanumeric plus _-+. only
function clean_filename () {
  echo "$1" | perl -p -e 'chomp;s/\s+/_/g;s/[^[:alnum:]_+\.-]*//g;lc;'
}

# find diff between backup and current files in pwd after a filtering operation
function diffbak () {
  for f in *.bak ; do
	  diff "${f%%.bak}" "$f"
  done
}

# push back original files in pwd after filtering operation
function restore () {
  for f in *.bak ; do
	  mv -v "$f" "${f%%.bak}"
  done
}

# rename old files in pwd with new extension
function rename_all () {
  for f in *.$1 ; do
	  mv "$f" "${f%%.$1}.$2"
  done
}

function psgrep() {
  ps auxww | grep -v grep | grep --color=auto -E "(^USER|$*)"
}

alias postman='nohup /opt/Postman/Postman > /dev/null &'

function dl() {
  echo $(date "+%FT%T") "$PWD" ':' "$@" >> $HOME/.dev.log
}

## A whole pile of git aliases and functions:
alias v='vim'
alias c='code'
alias cat='bat'
alias find='fd'
alias open='xdg-open'
alias gaa='git add --all -v'
alias gb='git branch'
alias gbls='git branch -av'
alias gcl='git clone'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdoh='git diff origin HEAD'
alias gl='git log'
alias glg='git log --graph --pretty=format":%C(yellow)%h%Cblue%d%Creset %s %C(white) %an,%ar%Creset" --abbrev-commit --decorate'
alias glgh='git log --graph --pretty=format":%C(yellow)%h%Cblue%d%Creset %s %C(white) %an,%ar%Creset" --abbrev-commit --decorate | head'
alias glo='git log --oneline --decorate'
alias glog='git log'
alias gloh='git log --oneline --decorate | head'
alias gls='git ls-files'
alias gpl='git pull'
alias gploh='git pull origin HEAD'
alias gps='git push'
alias gpsoh='git push -u origin HEAD'
alias gpsfoh='git push -fu origin HEAD'
alias gpsfuoh='git push -fu origin HEAD'
alias gr='git remote'
alias grls='git remote -v'
alias gyolo='git add --all && git commit -m YOLO && git push -fu origin HEAD'
alias grh='git reset --hard'

## I use this to make we-sized images in a "web" subdirectory
# Usage: mkweb *.png *.jpg [...]
alias mkweb='mkdir -p web; mogrify -verbose -path web -format jpg -resize 1024 -quality 60 '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export WORKON_HOME=$HOME/.virtualenvs

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

source /usr/local/bin/virtualenvwrapper.sh

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH:/snap/bin
source "$GOPATH/src/github.com/sachaos/todoist/todoist_functions.sh"

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
