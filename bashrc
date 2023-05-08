# Bash knows 3 diferent shells: normal shell, interactive shell, login shell.

test -z "$PROFILEREAD" && . /etc/profile

alias c='clear'
alias d='docker'
[ -f /etc/redhat-release ] && alias f='firewall-cmd'
alias h='history | grep -i'
[ -f /etc/SuSE-release ] && alias l='ls -lF --ignore=.*' || alias l='ls -l --color'
alias k='kubectl'
alias m='less'
alias pm='podman'
alias p='ps -ef | grep -i'
alias r='rpm -qa | grep -i'
alias s='systemctl'
alias t='timedatectl'
alias v='vi'

[ -x /usr/bin/ansible ] && alias ap='ansible-playbook'
alias eg='egrep -v "(^*#|^ *$)"'
alias fl='ip -s -s neigh flush all'
[ -f /etc/redhat-release ] && alias fs='firewall-status'
alias grep='grep --color=auto'		# some distros don't have this
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -pi'
alias lz='ls -laZ --color'
alias pf='ps fauxw'
alias dc='cd'		# have to add this because I'm an idiot typing
alias ds='df -h | grep -v snap | grep ^/dev'
alias lsoff='lsof -P -iTCP -sTCP:LISTEN'
alias iftop='export NCURSES_NO_UTF8_ACS=1 && iftop $@'
alias sd='sudo su -'
[ -f /usr/bin/htop ] && alias top='htop'
alias vi='vim'

# lvm
alias pvs='pvs --units g'
alias vgs='vgs --units g'
alias lvs='lvs --units g'

# kubernetes
[ -x /snap/bin/microk8s.kubectl ] && alias kubectl=microk8s.kubectl
[ -x /usr/bin/kubectl ] && source <(kubectl completion bash)
complete -F __start_kubectl k

# git
alias gr='git remote show origin'
alias gl1='git log --graph --decorate --pretty="format:%C(auto)%h %ad %C(green)%an %C(cyan)%s" --abbrev-commit'
alias gl2='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gl3='git log --graph --date=short --abbrev-commit --pretty=format:"%h %cd %an - %s"'

PATH=/usr/sbin:/sbin:/usr/bin:/bin:/usr/local/bin:/usr/local/sbin:/snap/bin
export PATH

#────────
# Colors
#────────
[ -f $HOME/.dircolors ] && eval `dircolors -b $HOME/.dircolors`	# tty

prompt_status() { local e=$?; [ $e != 0 ] && echo -e "$e "; }
[ -n "$BYOBU_CHARMAP" ] || BYOBU_CHARMAP=$(locale charmap 2>/dev/null || echo)
prompt_symbol() {
    if [ "$USER" = "root" ]; then
        printf "%s" "#";
    else
        printf "%s" "\$"
    fi
}

if [ -f /etc/redhat-release ] ; then
    if grep -q 'Red Hat' /etc/redhat-release ; then
        # red
        PS1="\[\033[38;2;255;102;102m\]\u@\h\[\033[00m\]:\[\033[29m\]\w\[\033[00m\]$(prompt_symbol) "
    elif grep -q 'Fedora' /etc/redhat-release ; then
        # blue
        PS1="\[\033[1;37;44m\]\u@\h\[\033[00m\]:\[\033[29m\]\w\[\033[00m\]$(prompt_symbol) "
    else
        # white (CentOS and others)
        PS1="\[\033[38;2;0;0;0m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(prompt_symbol) "
    fi
else
    # green
    PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(prompt_symbol) "
fi 
export PS1

#──────────
# The rest
#──────────
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH

# The '&' suppresses duplicate entries.
export HISTSIZE=10000
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
# This has been more trouble than it's worth
#export HISTIGNORE="&:[ \t]*:pwd:exit:cd:l:ls:ls -l:history"

# commands common to all logins
if ! [ $TERM ] ; then
    eval `tset -s -Q`
    case $TERM in
      con*|vt100) tset -Q -e ^?
        ;;
    esac
fi

# try to set DISPLAY smart (from Hans) :)
if test -z "$DISPLAY" -a "$TERM" = "xterm" -a -x /usr/bin/who ; then
    WHOAMI="`/usr/bin/who am i`"
    _DISPLAY="`expr "$WHOAMI" : '.*(\([^\.][^\.]*\).*)'`:0.0"
    if [ "${_DISPLAY}" != ":0:0.0" -a "${_DISPLAY}" != " :0.0" \
         -a "${_DISPLAY}" != ":0.0" ]; then
        export DISPLAY="${_DISPLAY}";
    fi
    unset WHOAMI _DISPLAY
fi

export DISPLAY
export EDITOR=vi
umask 022
