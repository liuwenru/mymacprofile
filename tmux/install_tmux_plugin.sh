envname=$(uname)
case ${envname} in
Linux)
  dnf install xclip
  ;;
Darwin)
  brew install reattach-to-user-namespace
  ;;
*) ;;
esac

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/tmux.conf.local ~/.tmux.conf.local
