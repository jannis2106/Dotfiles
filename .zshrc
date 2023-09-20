### Exports ###

# RUST
export RUST_BACKTRACE=full
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/library"

# XDG
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache

# follow XDG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# ZSH
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export HISTFILE="$XDG_STATE_HOME"/zsh/history

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

### Theme ###
ZSH_THEME="agnoster"

### Plugins ###
plugins=(
	git 
	zsh-autosuggestions
	copyfile
    vi-mode
)

source $ZSH/oh-my-zsh.sh

INSERT_MODE_INDICATOR="%F{yellow}+%f"
bindkey -M viins 'jj' vi-cmd-mode

ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                tar xvf $1       ;;
            *.cbr|*.rar)
                unrar x -ad ./$1 ;;
            *.gz)
                gunzip ./$1      ;;
            *.cbz|*.epub|*.zip)
                unzip ./$1       ;;
            *.z)
                uncompress ./$1  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                7z x ./$1        ;;
            *.xz)
                unxz ./$1        ;;
            *)
                echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

### Aliases ###

# confirm commands
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# change "ls" to "exa"
alias ls="exa -al --group-directories-first"
alias lt="exa -aT --group-directories-first --icons"

# change "cat" to "bat"
alias cat="bat"

# pacman / yay
alias pac="sudo pacman"
alias pacsyu="sudo pacman -Syu"		    # update package list and upgrade all packages afterwards
alias yaysua="yay -Sua --noconfirm" 	# synchronize and update AUR packages

# vim
alias v="nvim"

# clear
alias c="clear"

# formatted date and time
alias ddate="date +'%R - %a, %B %d, %Y'"
alias ttime="while true; do tput clear; date +'%H : %M : %S' | figlet ; sleep 1; done"

# git
alias add="git add"
alias commit="git commit -m"
alias push="git push"
alias status="git status"

# bare git repo for dotfiles
alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
alias cadd="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME add"
alias ccommit="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME commit -m"
alias cpush="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME push"
alias cstatus="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME status"

alias hltvf="python ~/workspace/HLTVTerminal/App.py"
alias hltvp="python ~/workspace/HLTVTerminal/Print.py"

alias ha="nvim ~/Documents/Schule/ha.md"
alias todo="nvim ~/Documents/todo.md"

# tex file template (tt filename.tex)
alias tt="cp ~/tex/template.tex"

alias cal="cal -m"

# twitch
alias blast="dl-stream -cw twitch.tv/blastpremier"
alias esl="dl-stream -cw twitch.tv/eslcs"

export PATH=/usr/bin/swww:/home/jannis/.cargo/bin:$PATH
