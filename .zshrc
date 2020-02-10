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

source ~/vxr-gcloud-common-alias

alias help='tldr'

alias k9='k9s'
alias td='todoist'
alias tdl='td s && td list'
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
alias fzf="fzf -m"
alias t="tmux"
alias toc="doctoc"
alias cal="gcalcli agenda"
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
alias gploc='git pull origin $(current_branch)'
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

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
export ANDROID_HOME=/home/loi/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME/bin:/usr/share/logstash/bin

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH"
alias antlr4='java -jar /usr/local/lib/antlr-4.7.1-complete.jar'
alias grun='java org.antlr.v4.gui.TestRig'

function sql() {
  cloud_sql_proxy -instances=vexere-218206:asia-southeast1:$1=tcp:5432
}

alias studio='nohup /home/loi/vexere/android-studio/bin/studio.sh > /dev/null &'

alias ra='react-native run-android'

alias v='vim'

function emulator { ( cd "$(dirname "$(whence -p emulator)")" && ./emulator "$@"; ) }
alias emu="$ANDROID_HOME/tools/emulator"
alias nexus="nohup emulator -avd doo1 > /dev/null &"

port_forward_redis="gcloud compute ssh  database-servers-for-dev -- -N -L 6379:10.0.1.3:6379"

function portkill(){
  sudo kill -9 $(lsof -t -i:$1);
}


function kill_tunnel_port(){
    portkill 6379 && portkill 6380 && portkill 6383
}

