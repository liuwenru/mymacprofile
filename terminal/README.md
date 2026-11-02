# 轻量化的zsh 提示符解决方案

https://github.com/sindresorhus/pure


https://github.com/zsh-users/zsh-autosuggestions

https://github.com/hyperupcall/autoenv

# pure 配置

PURE_GIT_PULL=0
PURE_GIT_UNTRACKED_DIRTY=0



# zsh-autosuggestions 配置

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4,bold"


# autoenv 配置
AUTOENV_ENV_FILENAME=".env"
AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
AUTOENV_ENABLE_LEAVE="1"
AUTOENV_ASSUME_YES="1"