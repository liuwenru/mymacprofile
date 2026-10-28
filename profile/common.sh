# Interactive settings shared by Bash and Zsh; environment lives in env.sh.
export TERM=xterm-256color

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
