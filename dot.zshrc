setopt appendhistory autocd notify
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
PROMPT='$USER@%m %B%1~%b %# '
RPROMPT='$(git_super_status)'

## end of git things

###### emacs compatibility
bindkey -s "^x^f" $'^aemacsclient -nw -c '
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
zstyle :compinstall filename '/home/ed/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias wip='git commit -a -m "wip"'
alias gco='git checkout '
alias ga='git add '
alias gd='git diff --color=always '
alias ll='ls -al'

export JAVA_HOME=/usr
export PATH=~/bin:$PATH
# :~/Apps/maven/bin:~/Apps/terraform/current
# export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -nw -c'
export EDITOR='emacsclient -nw -c'

[[ -s "/usr/local/bin/aws_zsh_completer.sh" ]] && source /usr/local/bin/aws_zsh_completer.sh

my-accept-line () {
    if [ ${#${(z)BUFFER}} -eq 0 ]; then
        echo
        if git rev-parse --git-dir > /dev/null 2>&1 ; then
            git status
        fi
    fi
    zle accept-line
}
# create a widget from `my-accept-line' with the same name
zle -N my-accept-line
# rebind Enter, usually this is `^M'
bindkey '^M' my-accept-line

[[ -f "/home/ed/.zsh/aws-credentials" ]] && source /home/ed/.zsh/aws-credentials
export GOPATH=~/dev/.go-path

# export PATH=/home/ed/dev/.go-path/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/ed/.gvm/bin/gvm-init.sh" ]] && source "/home/ed/.gvm/bin/gvm-init.sh"
