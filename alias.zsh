
# .zsh files that are put in $ZSH_CUSTOM/{file_name}.zsh will be automatically loaded by OMZ as default
# reference: https://github.com/robbyrussell/oh-my-zsh/issues/5200
# the more the explicitly alias can be the better for readability and history search

### utils ###
# check if a shell service exist

gacp () {
    git add .
    git commit -m "$*"
    git push
}

install_gcloud () {
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk
}

is_service_exist () {
    local service="$1"
    # check if service exist and not an alias by checking its execute file location
    if service_loc="$(type -p "${service}")" || [[ -z $service_loc ]]; then
        return
    fi
    # a proper way to use bash function that return boolean: https://stackoverflow.com/a/43840545
    false
}

### alias ###
alias llink="la | grep '\->'" # list all link

# ag #
if is_service_exist ag; then
    alias ag="ag -i --pager=less"
fi

# bat #
bat-install () {
    if ! is_service_exist bat; then
	export VER="0.6.1"
	wget https://github.com/sharkdp/bat/releases/download/v${VER}/bat_${VER}_amd64.deb -O /tmp/bat_${VER}_amd64.deb
	sudo dpkg -i /tmp/bat_${VER}_amd64.deb
    fi
}

# direnv #
direnv-install () {
    if is_service_exist apt-fast; then # debian based
        apt-fast install -y --no-install-recommends direnv
    fi
    ln -sfn ~/workspace/dotfiles/direnv/direnvrc ~/.direnvrc
}

# docker #
if is_service_exist docker; then
    # new kind of alias, better at history search
    alias docker-rm-dangling-images="docker images -qf dangling=true | xargs -r docker rmi"
    alias docker-rm-dangling-volumes="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    docker-rm-group-images () {
	local pattern="$1"
	cmd="docker images | grep "${pattern}" | awk '{print \$3}' | xargs docker rmi"
        echo ${cmd} && eval ${cmd}
    }
    docker-rm-group-ps () {
	local pattern="$1"
	cmd="docker ps -a | grep "${pattern}" | awk '{print \$1}' | xargs docker rm"
        echo ${cmd} && eval ${cmd}
    }

    alias docker-run-dotfiles="docker start dotfiles_env && docker attach dotfiles_env"
    alias docker-run-sdoc="docker start sdoc_env && docker attach sdoc_env"
    # docker run with interactive mode, image will be deleted after run
    docker-run-it () {
        local image="$1" entrypoint="${2:=/bin/sh}"
        local tmpName="${1//[:.]/_}" # replace ':' with '_'
        cmd="docker run -it --rm --name '${tmpName}' --entrypoint ${entrypoint} "${@:3}" ${image}"
        echo ${cmd} && eval ${cmd}
    }
fi

if is_service_exist docker-compose; then
    alias compose="docker-compose"
    alias compose-build="docker-compose build --force-rm"
    alias compose-up="docker-compose up -d --build"
fi

# fzf #
if is_service_exist fzf; then
    alias fzf="fzf --color=16"
fi

# git #
git-setup () {
    ln -sfn ~/workspace/dotfiles/git/gitconfig ~/.gitconfig
    ln -sfn ~/workspace/dotfiles/git/gitignore ~/.gitignore
    ln -sfn ~/tig/tigrc                        ~/.tigrc
    # install tig
    if is_service_exist apt-fast; then # debian based
        apt-fast install -y --no-install-recommends tig
    elif is_service_exist pacman; then # arch based
        sudo pacman -S tig --noconfirm --needed
    fi
}

# grc #
grc-install () {
    # pull or clone git repo
    git -C /tmp/grc pull || git clone https://github.com/garabik/grc.git
    # install
    (cd /tmp/grc && sudo chmod +x install.sh && ./install.sh)
}

# java #
java-install () {
    if is_service_exist apt-fast; then # debian based
        # apt-fast install -y --no-install-recommends openjdk-8-jdk maven #openjdk
	sudo add-apt-repository ppa:webupd8team/java && sudo apt update && \
	    apt-fast install -y --no-install-recommends oracle-java8-set-default # oracle jdk
    fi
    snap install intellij-idea-community --classic
    # add java environment variable
    grep -qF 'JAVA_HOME' /etc/environment || echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre/bin/java"' | sudo tee --append /etc/environment
}

# oh-my-zsh
oh_my_zsh-install () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

# pacman #
if is_service_exist pacman; then
    alias pac-install="sudo pacman -S --noconfirm" # install
    alias pac-remove="sudo pacman -R --noconfirm" # remove
    alias pac-search="pacman -Ss" # search
    alias pac-update_system="sudo pacman -Syu --noconfirm" # update system
fi

# pet #
# snippet manager tool
pet-install () {
    if ! is_service_exist pet; then
	export VER="0.3.2"
	wget https://github.com/knqyf263/pet/releases/download/v${VER}/pet_${VER}_linux_amd64.deb -O /tmp/pet_${VER}_linux_amd64.deb
	sudo dpkg -i /tmp/pet_${VER}_linux_amd64.deb
    fi
    ln -sfn ~/workspace/dotfiles/pet/config.toml ~/.config/pet/config.toml
}

# postman #
# postman-install () {
# 	cd /tmp || exit
# 	echo "Downloading Postman ..."
# 	wget https://dl.pstmn.io/download/latest/linux -O postman.tar.gz
# 	tar -xzf postman.tar.gz
# 	sudo rm postman.tar.gz

# 	echo "Installing to opt..."
# 	if [ -d "/opt/Postman" ];then
# 		sudo rm -rf /opt/Postman
# 	fi
# 	sudo mv Postman /opt/Postman

# 	echo "Creating symbolic link..."
# 	if [ -L "/usr/bin/postman" ];then
# 		sudo rm -f /usr/bin/postman
# 	fi
# 	sudo ln -s /opt/Postman/Postman /usr/bin/postman
# }

postgres-install () {
    docke pull postgres:11.1
    mkdir -p $HOME/docker/volumes/postgres
    docker run --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
}

# python #
python-install () {
    # install pip
    apt-fast install -y --no-install-recommends python3-pip
    # add python to update-alternatives
    # some of Ubuntu service require python2 to run, therefore we should not run set python3 as default
    # update-alternatives --install /usr/bin/python python /usr/bin/python3 1
}

# rainbow #
# use to customize color for console ouput (Ex: tailing log file)
rainbow-install () {
    # pull or clone git repo
    git -C /tmp/rainbow pull || git clone git://github.com/nicoulaj/rainbow.git /tmp/rainbow
    # install
    (cd /tmp/rainbow && pip install jinja2 --user && python setup.py build && sudo python setup.py install)
}

# tmux #
tmux-install () {
    if is_service_exist apt-fast; then # debian based
        apt-fast install -y --no-install-recommends tmux
    elif is_service_exist pacman; then # arch based
        sudo pacman -S tmux --noconfirm --needed
    fi
    # install tmux plugin manager
    if cd ~/.tmux/plugins/tpm ; then
        git -C ~/.tmux/plugins/tpm pull;
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    # tmux config files
    ln -sfn ~/workspace/dotfiles/tmux/tmux.conf ~/.tmux.conf # link configuration file
    ln -sfn ~/workspace/dotfiles/tmux/tmuxp     ~/.tmuxp
    ~/.tmux/plugins/tpm/bin/install_plugins
    # install tmuxp & plugins
    sudo -H pip3 install tmuxp
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

### ubuntu ###
ubuntu-provision () {
    # install core program
    # install apt-fast
    sudo add-apt-repository ppa:apt-fast/stable
    sudo apt-get update
    sudo apt-get -y install --no-install-recommends apt-fast
    # install apt packages
    apt-fast install --no-install-recommends -y \
	autossh direnv docker-compose fcitx-unikey gnome-tweak-tool make silversearcher-ag snapd supervisor xclip \
	network-manager-l2tp-gnome wget httpie
    # install snap packages
    snap install docker postman
    # setup vietnamese input
    im-config -n fcitx # set fcitx as default input method
}
# install others program
ubuntu-post-provision () {
    apt-fast install -y --no-install-recommends mpv nautilus-dropbox skype transmission
    snap install clementine telegram-desktop tldr
    snap install slack --classic
}

# show usage of a different directory by passing it as the first argument
# show more levels by passing a number as the second. For example,
# usage . 2 shows space usage of the current directory 2 directories deep.
# This requires a version of sort that knows of the -h flag
usage() {
    du -h --max-depth="${2:-1}"\
      "${2:-.}" |\
        sort -h |\
        sed "s:\./::" |\
        sed "s:$HOME:~:"
}

# vim #
vim-install () {
    # requre python and pip installed
    # gui-vim should be installed instead of terminal vim because it support clipboard
    if is_service_exist apt; then
	sudo apt remove -y vim vim-runtime gvim # remove pre-installed vim

	# build vim with latest version (with clipboard support)
	# https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
	if cd /tmp/vim ; then
	    git -C /tmp/vim pull;
	else
	    git clone https://github.com/vim/vim.git /tmp/vim
	fi
	sudo apt build-dep vim
	(
	    cd /tmp/vim                                                              && \
	    sudo make distclean                                                      && \
	    ./configure --enable-multibyte                                              \
			--enable-python3interp=yes                                      \
			--enable-gui=gtk3                                               \
			--with-x                                                        \
			--enable-cscope                                                 \
			--prefix=/usr/local                                             \
                        # too many unessary features --with-features=huge                                            \
	    sudo make                                                                && \
	    sudo make install
	)
	# make vim the default application
	sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
	sudo update-alternatives --set editor /usr/local/bin/vim
	sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
	sudo update-alternatives --set vi /usr/local/bin/vim
	sudo rm -r /tmp/vim

    elif is_service_exist pacman; then
        sudo pacman -S gvim ctags xclip --noconfirm --needed
    fi

    # install other tools for plugins
    sudo pip3 install python-language-server ipdb jsbeautifier

    # setup config files
    mkdir -p ~/.vim/after/ftplugin
    ln -sfn ~/workspace/dotfiles/vim/ctags      ~/.ctags
    ln -sfn ~/workspace/dotfiles/vim/vimrc      ~/.vimrc
    ln -sfn ~/workspace/dotfiles/vim/vim-conf   ~/.vim-conf
    ln -sfn ~/workspace/dotfiles/vim/ftplugin/* ~/.vim/after/ftplugin/

    # install vim-anywhere, require gvim (or a derivative)
    # https://github.com/cknadler/vim-anywhere
    curl -fsSL https://raw.github.com/cknadler/vim-anywhere/master/install | bash
    # to update: ~/.vim-anywhere/update
}
if is_service_exist vim; then
    alias vim-update-plugin="vim +PlugUpdate +qall"
fi

# xinput
declare builtinKeyboard="AT Translated Set 2 keyboard"
alias xinput-list-keyboard=$'xinput list | grep ${builtinKeyboard}'
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias xinput-list-keyboard-id=$'xinput list | grep ${builtinKeyboard} | awk \'{print $7}\' | cut -c 4-5'
alias xinput-disable-keyboard=$'xinput float $(xinput-list-keyboard-id)'
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput-enable-keyboard=$'xinput reattach $(xinput-list-keyboard-id) 3'

# utils #

# use xdg-open to open any file with default app
# should use & at the end to run the process in background otherwise we cannot continue using the cli
# ex: open file.txt &
if is_service_exist xdg-open; then
    alias open="xdg-open"
fi

### AUTO_CD ###
# zsh will automatically cd to a directory if it is given as command on the command line
# and it is not the name of an actual command. Ex:
# % /usr
# % pwd
# /usr
# reference: https://askubuntu.com/questions/758496/how-to-make-a-permanent-alias-in-oh-my-zsh

# fzf is better

# hash -d dotfiles=~/.dotfiles
# hash -d s-doc=~/.s-doc
# hash -d workspace=~/workspace

