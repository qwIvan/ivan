export ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="jonathan"
DISABLE_AUTO_UPDATE="true"
plugins=(fasd git adb history mvn npm pip web-search extract d gradle meteor systemadmin colored-man-pages history-substring-search sprunge httpie urltools common-aliases themes gem github singlechar battery colorize screen archlinux rsync gulp safe-paste vi-mode tmux alias-tips python sbt coffee compleat dircycle dirpersist docker encode64 pep8 pylint redis-cli scala sublime sudo supervisor systemd vagrant virtualenv cabal docker-compose django bower nmap gnu-utils fancy-ctrl-z postgres zsh-navigation-tools)
# ruby rvm per-directory-history rails)

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source /usr/share/pinyin-completion/shell/pinyin-comp.zsh
source $ZSH/oh-my-zsh.sh
source ~/alias-tips/alias-tips.plugin.zsh
for z in `ls /usr/share/zsh/plugins/*/*.zsh`;do
  source $z
done
i () curl ip.cn/$1
alias sudo='sudo '
alias _='sudo '
alias tree="tree -C"
transfer () {
  # write to output to tmpfile because of progress bar
  tmpfile=$( mktemp -t transferXXX )
  curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
  cat $tmpfile;
  rm -f $tmpfile;
}
lf () {
  echo -n "'"
  test -z $@ || echo -n $@/
  ls -t $@ | head -n 1 | tr -d '\n'
  echo "'"
}
export LESS="-RFXeKi"
unalias c
le () {
  unbuffer $@ | less
}
#c () {
#  if [[ -t 1 ]]; then
#    le ccat --bg=dark $@
#  else
#    cat $@
#  fi
#}
pkg () {
	pacman -Si $1 2> /dev/null | head -n 1 | grep -Po '(?<=:\s).*' | xargs -i google-chrome-stable https://www.archlinux.org/packages/{}/x86_64/$1/ | xargs test || google-chrome-stable https://aur.archlinux.org/packages/$1 > /dev/null
}
loop () {
  while true
  do
    $@
    sleep 1
  done
}
e () {
    if [ -z $1 ]; then
        vim
    elif [ -f $1 ]; then
        sudo -u $(stat -c %U $1) vim $@
    elif [ ! -w $(dirname $1) ]; then
        sudo -u $(stat -c %U $(dirname $1)) vim $@
    else
        vim $@
    fi
}
alias c=/bin/bat
alias pareps="le pacaur -Ss"
alias tpp="tree --prune -P"
export CHEATCOLORS=true
alias rsync-compare="rsync -ani -vv"
rsync-compare-into() rsync -aHxi -vv --progress --compare-dest=$2 $1 $3
alias x=extract
alias ls="ls -rhtc --color=auto"
alias l="ls -Flrahtc --color=auto"
alias axel="axel -a"
alias pacfl="pacman -Ql"
alias pacown="pacman -Qo"
alias plunt="sudo netstat -plunt"
alias pain="pacaur -S --noedit"
alias rm=trash
alias sumi="awk '{s+=\$1} END {print s}'"
alias ips="sudo iptables -t"
alias ipsm="sudo iptables -t mangle -L -n --line-numbers"
alias ipsn="sudo iptables -t nat -L -n --line-numbers"
alias chrome=google-chrome-stable
alias history="fc -i -l 1"
alias -g A1="| awk \"{print \\\$1}\""
alias -g A2="| awk \"{print \\\$2}\""
alias -g A3="| awk \"{print \\\$3}\""
alias -g A4="| awk \"{print \\\$4}\""
alias -g A5="| awk \"{print \\\$5}\""
alias -g L="| less -R"
alias -g X="| xargs"
alias -g XI="| xargs -i"
alias -g PP="\`clippaste\`"
alias -g V="--version"
alias -g SL="| tr ' ' '\n'"
alias -g G="| grep -iP"
unalias ping
unalias gm
tcb () {
  tldr $1
  cheat $1
  bro $1
}
fiy () {
  fanyi $1
  ici $1
  yd $1
  trans $1
}
export PATH=~/.local/bin:$PATH
export PATH=$PATH:/usr/bin/core_perl
#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH=$PATH:/usr/bin/vendor_perl/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/lib/w3m/
export PATH=$PATH:/usr/share/bcc/tools/
#for p in ~/.gem/ruby/*/bin;do
#  PATH=$p:$PATH
#done
export VISUAL="vim"
export EDITOR="vim"
export PYTHONSTARTUP=~/.pythonstartup.py
export GPG_TTY=$(tty)
bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down
bindkey "^F" forward-word
bindkey "^K" autosuggest-execute
bindkey "^T" fasd-complete
#bindkey '`' vi-cmd-mode
#eval $(thefuck --alias)  # so slow!!

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_DEFAULT_OPTS="--exact"

autoload -U +X bashcompinit
bashcompinit
#source /usr/share/bash-completion/completions/storm
#source /etc/profile.d/android-ndk.sh
