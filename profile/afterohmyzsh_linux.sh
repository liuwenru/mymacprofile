# Linux zsh settings that must run after oh-my-zsh.sh, sourced by zsh/zshrc.
# oh-my-zsh runs compinit again, so completion registrations made earlier
# can be replaced; register them here instead.

# zsh-completion-lite from mystatictools, installed to ~/.local/share.
# Commands listed in MINI_ZSH_OFFICIAL_COMPLETION keep zsh's own completion.
# MINI_ZSH_OFFICIAL_COMPLETION='git'
[[ -r $HOME/.local/share/zsh-completion-lite/init.zsh ]] &&
  source "$HOME/.local/share/zsh-completion-lite/init.zsh"
