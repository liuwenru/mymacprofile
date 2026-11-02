envname=$(uname)
case ${envname} in
Linux)
  dnf install xclip
  ;;
Darwin)
  brew install reattach-to-user-namespace
  # tmux-toggle-scratch 的清理脚本使用 GNU diff 的 --old-line-format 参数，
  # macOS 自带 /usr/bin/diff 不支持，导致窗口关闭后 scratch 会话不会被清理。
  # diffutils 会提供 /opt/homebrew/bin/diff，tmux 的 PATH 中它排在 /usr/bin 之前。
  brew install diffutils
  ;;
*) ;;
esac

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $(pwd)/tmux.conf ~/.tmux.conf
