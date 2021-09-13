
# export PATH
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export PATH=/usr/local/vim/bin:$PATH
# alias setting
alias svn='svn --username liuwr --password ${svnpassword}'
alias ll='ls -lh'
alias l='ls -lh'
alias git='git --no-pager'
alias gits='git status'


envname=$(uname)
case ${envname} in
    Linux)
        # echo -n " welcome Linux dev............."
        export PATH=/usr/local/maven/bin:$PATH
        export ANT_HOME=/usr/local/ant
        export PATH=$ANT_HOME/bin:$PATH:/usr/local/gradle/bin:/usr/local/protobuf/bin
        export TERM=xterm-256color
        ;;
    Darwin)
        # echo -n " welcome Mac dev............."
        export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$HOME/.local/bin:$PATH
        export MANPATH="/usr/local/man:/Users/liuwenru/tools/mactools/dash_docs/linux_manpages:$MANPATH"
        export ANT_HOME="/Users/liuwenru/tools/mactools/ant"
        export MVN_HOME="/Users/liuwenru/tools/mactools/maven"
        export GRADLE_HOME="/Users/liuwenru/tools/mactools/gradle"
        export PATH="$MVN_HOME/bin:$ANT_HOME/bin:$GRADLE_HOME/bin:$PATH"
        export CFLAGS="-g -O0"
        export CXXFLAGS="-g -O0"
        export TERM=xterm-256color
        export PATH=$PATH:$HOME/bin:/usr/local/vim/bin
        ;;
    *)
        ;;
esac
