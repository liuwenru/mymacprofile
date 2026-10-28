# Environment shared by every shell, including non-interactive ones.
# Loaded by ~/.zshenv (zsh) and profile.sh (bash). Keep it silent and fast:
# no output, no external commands, only exports guarded by existence checks.

export LC_TIME=POSIX
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export TZ="Asia/Shanghai"
export LESS="-RXF"
export DOCKER_BUILDKIT=1
export BUILDX_EXPERIMENTAL=1
export no_proxy="*.epoint.com.cn,*.aliyun.*,192.168.0.0/16,172.0.0.0/8,127.0.0.1"

export JAVA_TOOL_OPTIONS="-Duser.language=en"
export MAVEN_ARGS="-T 4C"
export MAVEN_OPTS="-Xmx2048m -Xms1024m -Djava.awt.headless=true -DskipTests -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.artifact.threads=16 -Daether.dependencyCollector.impl=bf -Daether.connector.basic.downstreamThreads=20 -Daether.connector.basic.upstreamThreads=20 -Daether.dependencyCollector.bf.threads=10 -Daether.connector.https.securityMode=insecure -Daether.syncContext.named.time=300 -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.wagon.httpconnectionManager.maxPerRoute=100 -Dmaven.wagon.httpconnectionManager.maxTotal=200 -Dmaven.wagon.http.retryHandler.count=10"
export CFLAGS="-g -O0"
export CXXFLAGS="-g -O0"

# $OSTYPE avoids forking uname on every shell start.
case $OSTYPE in
  darwin*)
    export MANPAGER=cat
    export devtools_home="$HOME/workspace/devtools"
    export MANPATH="/usr/local/man:${devtools_home}/dash_docs/linux_manpages:${MANPATH:-}"
    # Static equivalent of `brew shellenv`, without running brew each time.
    if [[ -d /opt/homebrew ]]; then
      export HOMEBREW_PREFIX=/opt/homebrew
      export HOMEBREW_CELLAR=/opt/homebrew/Cellar
      export HOMEBREW_REPOSITORY=/opt/homebrew
      export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
    fi
    ;;
  linux*)
    export LANGUAGE="en_US:en"
    export PAGER=""
    export EDITOR=vim
    export VISUAL=vim
    export MANPATH="/usr/local/man:${MANPATH:-}"
    export devtools_home="$HOME/tools/linuxtools"
    export JAVA_7_HOME="$HOME/tools/jdks/1.7.80-oraclejdk"
    export JAVA_8_HOME="$HOME/tools/jdks/1.8.362-openjdk"
    export JAVA_9_HOME="$HOME/tools/jdks/9.0.4-oraclejdk"
    export JAVA_11_HOME="$HOME/.jabba/jdk/11.0.21-openjdk"
    export JAVA_17_HOME="$HOME/.jabba/jdk/17.0.5-openjdk"
    export PLAYWRIGHT_MCP_CDP_ENDPOINT="http://192.168.188.8:9222"
    export PLAYWRIGHT_CLI_SESSION="kernel"
    ;;
esac

if [[ -n ${devtools_home:-} ]]; then
  export ANT_HOME="${devtools_home}/ant"
  export MVN_HOME="${devtools_home}/maven"
  export GROOVY_HOME="${devtools_home}/groovy"
  export GRADLE_HOME="${devtools_home}/gradle"
fi

[[ -d $HOME/.local/share/pnpm ]] && export PNPM_HOME="$HOME/.local/share/pnpm"

# jabba keeps a "default" symlink; macOS JDKs nest their home under Contents/Home.
if [[ -d $HOME/.jabba/jdk/default/Contents/Home ]]; then
  export JAVA_HOME="$HOME/.jabba/jdk/default/Contents/Home"
elif [[ -d $HOME/.jabba/jdk/default/bin ]]; then
  export JAVA_HOME="$HOME/.jabba/jdk/default"
fi

# Add the nvm default Node without sourcing nvm.sh. Only an exact version such as
# v24.21.0 is resolved; aliases like "lts/*" are skipped and need nvm itself.
export NVM_DIR="$HOME/.nvm"
_nvm_default=""
[[ -r $NVM_DIR/alias/default ]] && read -r _nvm_default < "$NVM_DIR/alias/default"

# Each existing directory is moved to the front of PATH, so later entries win.
# Moving instead of skipping duplicates lets ~/.zprofile re-source this file to
# restore the order after macOS path_helper rearranges PATH.
for _dir in \
  "$HOME/.local/bin" "/usr/local/bin" "$HOME/.bin" \
  "${GRADLE_HOME:+$GRADLE_HOME/bin}" "${GROOVY_HOME:+$GROOVY_HOME/bin}" \
  "${MVN_HOME:+$MVN_HOME/bin}" "${ANT_HOME:+$ANT_HOME/bin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/llvm/bin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}" "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}" \
  "/usr/local/gdb/bin" "/usr/local/qemu/bin" \
  "${PNPM_HOME:-}" "$HOME/.cargo/bin" "$HOME/.jabba/bin" "${JAVA_HOME:+$JAVA_HOME/bin}" \
  "${_nvm_default:+$NVM_DIR/versions/node/v${_nvm_default#v}/bin}" \
  "/usr/local/nvim/bin" "$HOME/.opencode/bin"
do
  [[ -n $_dir && -d $_dir ]] || continue
  _path=":$PATH:"
  _path=${_path//":$_dir:"/:}
  _path=${_path#:}
  _path=${_path%:}
  PATH="$_dir${_path:+:$_path}"
done
export PATH
unset _dir _path _nvm_default

# gvm's default environment only exports GOROOT, GOPATH and PATH-like variables.
[[ -r $HOME/.gvm/environments/default ]] && source "$HOME/.gvm/environments/default"

# zsh: drop duplicates, keeping the first occurrence. gvm assigns the PATH string,
# which typeset -U does not dedupe, so re-assign the arrays once as well.
if [[ -n ${ZSH_VERSION:-} ]]; then
  typeset -U path manpath
  path=($path)
  manpath=($manpath)
fi
