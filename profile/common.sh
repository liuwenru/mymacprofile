# Common environment used by Bash and Zsh.
export LC_TIME=POSIX
export MANPATH="/usr/local/man:${MANPATH:-}"
export LANG=en_US.UTF-8
export TERM=xterm-256color
export PATH="$HOME/.bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export LESS="-RXF"
export DOCKER_BUILDKIT=1
export BUILDX_EXPERIMENTAL=1

# Existing aliases are intentionally preserved during the first migration.
alias dock=docker
alias dockeraarch64='DOCKER_HOST=ssh://root@192.168.182.150 docker'
alias dockeramd='DOCKER_HOST=ssh://root@192.168.188.150 docker'
alias svn='svn --username liuwr --password ${svnpassword}'
alias l='ls -lh'
alias git='git --no-pager'
alias gits='git status'
alias sshkeyadd="ssh-add ~/.ssh/id_rsa && ssh-add ~/.ssh/id_rsa_work"
alias mvn='mvn -DskipTests -Dmaven.test.skip=true'
alias rg='rg -S -U -a --binary'
alias sshlinuxamd64dev='ssh root@192.168.188.150'
alias moshlinuxamd64dev='mosh root@192.168.188.150'
alias tsshlinuxamd64dev='tssh --client --kcp root@192.168.188.150'
alias sshlinuxaarch64dev='ssh root@192.168.182.150'
alias moshlinuxaarch64dev='mosh root@192.168.182.150'
alias tsshlinuxaarch64dev='tssh --client --kcp root@192.168.182.150'
alias ll='ls -lah'
alias curl='curl -k'
alias wget='wget --no-check-certificate --show-progress'
alias tars='tar --strip-components=1'
alias ant='ant -Duser.home=$HOME/workspace/javaworkspace/'
alias s2sx='s2sx -max 100G'
if command -v nvim >/dev/null 2>&1; then
  alias vim=nvim
fi

export JAVA_TOOL_OPTIONS="-Duser.language=en"
export MAVEN_ARGS="-T 4C"
export MAVEN_OPTS="-Xmx2048m -Xms1024m -Djava.awt.headless=true -DskipTests -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.artifact.threads=16 -Daether.dependencyCollector.impl=bf -Daether.connector.basic.downstreamThreads=20 -Daether.connector.basic.upstreamThreads=20 -Daether.dependencyCollector.bf.threads=10 -Daether.connector.https.securityMode=insecure -Daether.syncContext.named.time=300 -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.wagon.httpconnectionManager.maxPerRoute=100 -Dmaven.wagon.httpconnectionManager.maxTotal=200 -Dmaven.wagon.http.retryHandler.count=10"
export CFLAGS="-g -O0"
export CXXFLAGS="-g -O0"
