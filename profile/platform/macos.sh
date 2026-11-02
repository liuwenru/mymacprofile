# Environment variables for macOS live in profile/env.sh.
alias sha256sum='shasum -a 256'
alias jd='java -Djd-gui.cfg=$HOME/workspace/devtools/jd-gui.cfg -jar ~/workspace/devtools/jd-gui.jar'
alias luyten='java -jar ~/workspace/devtools/luyten.jar'
alias tar='COPYFILE_DISABLE=1 tar --exclude=".*"'
alias mat='cd ~/workspace/devtools && open -n MemoryAnalyzer.app && cd -'
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias keychain='open /System/Library/CoreServices/Applications/Keychain\ Access.app'
alias mountsshfsaarch64='sshfs -o reconnect -o follow_symlinks root@192.168.182.150:/root ~/Downloads/Troubleshooting-work/linuxaarch64workspace'
alias mountsshfsamd64='sshfs -o reconnect -o follow_symlinks root@192.168.188.150:/root ~/Downloads/Troubleshooting-work/linuxamd64workspace'

# MinIO client, not Midnight Commander; zsh needs bashcompinit for `complete`.
if [[ -x $HOME/.local/bin/mc ]]; then
  alias mc='mc --insecure --dp'
  complete -o nospace -C "$HOME/.local/bin/mc" mc
fi

export GPG_TTY="$(tty)"
