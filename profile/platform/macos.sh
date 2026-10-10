alias sha256sum='shasum -a 256'
alias jd='java -Djd-gui.cfg=/Users/liuwenru/workspace/devtools/jd-gui.cfg -jar ~/workspace/devtools/jd-gui.jar'
alias luyten='java -jar ~/workspace/devtools/luyten.jar'
alias tar='COPYFILE_DISABLE=1 tar --exclude=".*"'

export MANPAGER=cat
export GPG_TTY="$(tty)"
export devtools_home="/Users/liuwenru/tools/mactools"
export MANPATH="/usr/local/man:${devtools_home}/dash_docs/linux_manpages:${MANPATH:-}"
export ANT_HOME="${devtools_home}/ant"
export MVN_HOME="${devtools_home}/maven"
export GROOVY_HOME="${devtools_home}/groovy"
export GRADLE_HOME="${devtools_home}/gradle"
export PATH="$ANT_HOME/bin:$MVN_HOME/bin:${GROOVY_HOME}/bin:$GRADLE_HOME/bin:$PATH"
