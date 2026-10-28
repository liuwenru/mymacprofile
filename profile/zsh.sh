# zsh-autoenv settings. Security-related behavior is preserved for now.
export AUTOENV_ENV_FILENAME=".env"
export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
export AUTOENV_ENABLE_LEAVE="1"
export AUTOENV_ASSUME_YES="1"

export SAVEHIST=300
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4,bold"
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_MANUAL_REBIND="false"
