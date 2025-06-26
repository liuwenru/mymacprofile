# export SET
export LC_TIME=POSIX # 影响显示的时间是12小时制或者24小时制
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export TERM=xterm-256color
export PATH=$HOME/.bin:/usr/local/bin:$HOME/.local/bin:$PATH
#export GOPROXY=https://goproxy.io,direct
export LESS="-RXF" #mycli 等插件在工作时会每次都单独显示一次结果，所以使用此变量控制
export DOCKER_BUILDKIT=0

# alias settings
alias dock=docker
alias dockeraarch64='DOCKER_HOST=ssh://root@192.168.182.150 docker'
alias dockeramd='DOCKER_HOST=ssh://root@192.168.188.150 docker'
alias svn='svn --username liuwr --password ${svnpassword}'
alias l='ls -lh'
alias git='git --no-pager'
alias gits='git status'
alias sshkeyadd="ssh-add ~/.ssh/id_rsa && ssh-add ~/.ssh/id_rsa_work"
alias mvn='mvn -DskipTests -Dmaven.test.skip=true'
alias sshlinuxamd64dev='ssh root@192.168.188.150'
alias moshlinuxamd64dev='mosh root@192.168.188.150'
alias sshlinuxaarch64dev='ssh root@192.168.182.150'
alias moshlinuxaarch64dev='mosh root@192.168.182.150'
alias sshlinuxaarch64openeulerdev='ssh root@192.168.182.149'
alias moshlinuxaarch64openeulerdev='mosh root@192.168.182.149'
alias sshmacdev='ssh root@192.168.149.192'
alias ll='ls -lah'
alias curl='curl -k'
alias wget='wget --no-check-certificate'
alias tars='tar --strip-components=1 '

# terminal Tools

# zsh https://github.com/hyperupcall/autoenv 配置
export AUTOENV_ENV_FILENAME=".env"
export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
export AUTOENV_ENABLE_LEAVE="1"
export AUTOENV_ASSUME_YES="1"

# oh my zsh settings
zstyle :omz:plugins:ssh-agent identities ~/.ssh/{id_rsa,id_rsa_work}
zstyle :omz:plugins:ssh-agent lazy yes

export SAVEHIST=300
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4,bold"
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_MANUAL_REBIND="false"

# Develop Settings
export JAVA_TOOL_OPTIONS="-Duser.language=en" # 设置默认的JDK属性
export MAVEN_ARGS="-T 4C"
export MAVEN_OPTS="-Xmx2048m -Xms1024m -Djava.awt.headless=true -DskipTests -Dmaven.test.skip=true  -Dmaven.javadoc.skip=true -Dmaven.artifact.threads=16 -Daether.dependencyCollector.impl=bf -Daether.connector.basic.downstreamThreads=20 -Daether.connector.basic.upstreamThreads=20 -Daether.dependencyCollector.bf.threads=10  -Daether.connector.https.securityMode=insecure -Daether.syncContext.named.time=300 -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.wagon.httpconnectionManager.maxPerRoute=100 -Dmaven.wagon.httpconnectionManager.maxTotal=200 -Dmaven.wagon.http.retryHandler.count=10"
export CFLAGS="-g -O0"
export CXXFLAGS="-g -O0"
# export NODE_OPTIONS=--openssl-legacy-provider
# Some bash or zsh complete
SHELLUSE=$(basename $SHELL)
completionfile=$(dirname $0)/../completions/
# if [[ $SHELLUSE == "zsh" ]]; then
#   fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src:${completionfile}
#   zstyle ':completion::complete:*' use-cache 1
#   autoload -Uz compinit
#   compinit -u
# fi
if command -v kubectl >/dev/null 2>&1; then
  # source <(kubectl completion ${SHELLUSE})
  source ${completionfile}/_kubectl
fi

envname=$(uname)
case ${envname} in
Linux)
  # echo -n " welcome Linux dev............."
  export LANG="en_US.UTF-8"
  export LANGUAGE="en_US:en"
  export LC_ALL="en_US.UTF-8"
  unset TMOUT
  export devtools_home="/root/tools/linuxtools"
  export ANT_HOME="${devtools_home}/ant"
  export MVN_HOME="${devtools_home}/maven"
  export GROOVY_HOME="${devtools_home}/groovy"
  export GRADLE_HOME="${devtools_home}/gradle"
  export PATH="$ANT_HOME/bin:$MVN_HOME/bin:${GROOVY_HOME}/bin:$GRADLE_HOME/bin:$PATH"
  export PAGER=""
  ;;
Darwin)
  # echo -n " welcome Mac dev............."
  alias sha256sum='shasum -a 256'
  alias jd='java -Djd-gui.cfg=/Users/liuwenru/workspace/devtools/jd-gui.cfg -jar ~/workspace/devtools/jd-gui.jar'
  alias luyten='java -jar ~/workspace/devtools/luyten.jar'
  export MANPAGER=cat
  export GPG_TTY=$(tty)
  export devtools_home="/Users/liuwenru/tools/mactools"
  export MANPATH="/usr/local/man:${devtools_home}/dash_docs/linux_manpages:$MANPATH"
  export ANT_HOME="${devtools_home}/ant"
  export MVN_HOME="${devtools_home}/maven"
  export GROOVY_HOME="${devtools_home}/groovy"
  export GRADLE_HOME="${devtools_home}/gradle"
  export PATH="$ANT_HOME/bin:$MVN_HOME/bin:${GROOVY_HOME}/bin:$GRADLE_HOME/bin:$PATH"
  ;;
*) ;;

esac
