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

export EDITOR=vim
export VISUAL=vim

alias dockerimages='docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>"'
