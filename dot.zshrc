export SAVEHIST=10000
export HISTFILE=~/.zsh/history

setopt INC_APPEND_HISTORY AUTOCD NOTIFY extendedglob
bindkey -e

stty stop undef
stty start undef

zstyle ':completion:*:urls' local
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:' group-name ''

function listMavenCompletions { reply=(dependancy:tree verify achetype:generate compile clean install test test-compile deploy package initialize -Dmaven.test.skip=true clojure:run clojure:repl) }
compctl -K listMavenCompletions mvn

function listLeinCompletions { reply=(change check classpath clean compile deploy deps do help install jar javac new plugin pom release repl retest run search show-profiles test trampoline uberjar update-in upgrade vcs version with-profile beanstalk ring server-headless war uberwar protobuf eastwood test2junit) }
compctl -K listLeinCompletions lein

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## git things

source ~/.zsh/zsh-git-prompt/zshrc.sh
PROMPT='$USER@%m %B%1~%b $(git_super_status)%# '
## RPROMPT='$(git_super_status)'

## end of git things

###### emacs compatibility
bindkey -s "^x^f" $'^aemacsclient -nw -c '
bindkey -s "^o^f" $'^aemacsclient -nw -c '
bindkey -s "^u^f" $'^afind . -iname "*^e*"^b^b'
bindkey -s "^u^g" $'^agrep -rHi "^e" .^b^b^b'
# bindkey -s "^x^b" $'^g screen -X windowlist -m ^M'
# bindkey -s "^xb" $'^g screen -X other'
# bindkey -s "^x2" $'^a^kscreen -X split ^M^y'
# bindkey -s "^x1" $'^a^kscreen -X only ^M^y'
bindkey ';5C' forward-word
bindkey ';5D' backward-word
export WORDCHARS='*?[]~=&;!#$%^(){}<>'

###### end of emacs compatibility

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' '' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' prompt 'Corrections (%e errors)'
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias wip='git commit -a -m "wip"'
alias gco='git checkout '
alias ga='git add '
alias gd='git diff --color=always '
alias ll='ls -al'
alias gc="git commit -m "
alias git-update-all='for d in `find . -type d -name .git` ; do pushd $d/.. ; git pull ; popd ; done'

export JAVA_HOME=/usr
export PATH=~/bin:$PATH
# :~/Apps/maven/bin:~/Apps/terraform/current
# export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -nw -c'
export EDITOR='emacsclient -nw -c'
export BOOT_JVM_OPTIONS=" -Xmx2g -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none -XX:-OmitStackTraceInFastThrow "

[[ -s "/usr/local/bin/aws_zsh_completer.sh" ]] && source /usr/local/bin/aws_zsh_completer.sh

my-accept-line () {
    if [ ${#${(z)BUFFER}} -eq 0 ]; then
        echo
        if git rev-parse --git-dir > /dev/null 2>&1 ; then
            git status
        else
            ls -l
        fi
    fi
    zle accept-line
}
# create a widget from `my-accept-line' with the same name
zle -N my-accept-line
# rebind Enter, usually this is `^M'
bindkey '^M' my-accept-line

[[ -f "~/.zsh/aws-credentials" ]] && source ~/.zsh/aws-credentials
export GOPATH=~/dev/.go-path

# export PATH=~/dev/.go-path/bin:$PATH

alias knife-live='KNIFE_ENV=intmc knife '


## insert start time of last command
strlen () {
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
}

preexec () {
    DATE=$( date +"[%H:%M:%S]" )
    local len_right=$( strlen "$DATE" )
    len_right=$(( $len_right+1 ))
    local right_start=$(($COLUMNS - $len_right))

    local len_cmd=$( strlen "$@" )
    local len_prompt=$(strlen "$PROMPT" )
    local len_left=$(($len_cmd+$len_prompt))

    RDATE="\033[${right_start}C ${DATE}"

    if [ $len_left -lt $right_start ]; then
        echo -e "\033[1A${RDATE}"
    else
        echo -e "${RDATE}"
    fi
}

### end

### pki gradle setup
export JAVA_OPTS=" -Djavax.net.ssl.keyStore=/home/aviso/.ssh/anna_secure_external-84.p12 -Djavax.net.ssl.keyStorePassword=UkXU3eYe9x2S -Xmx8192m "

export PATH=$PATH:~/.cargo/bin

print -Pn "\e]0;${USER}\a"

### end

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "~/.gvm/bin/gvm-init.sh" ]] && source "~/.gvm/bin/gvm-init.sh"
