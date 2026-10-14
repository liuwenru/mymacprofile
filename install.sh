#!/usr/bin/env bash

set -eu

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
dry_run=false
targets=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] TARGET...

Targets:
  profile  git  maven  gradle  vim  neovim  tmux  vscode  opencode  all

Examples:
  ./install.sh --dry-run all
  ./install.sh profile git
EOF
}

run() {
  if $dry_run; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

link_config() {
  local source=$1 target=$2 parent backup backup_index
  parent=${target%/*}

  if [[ -e $target || -L $target ]]; then
    if [[ $target -ef $source ]]; then
      printf 'Already linked: %s\n' "$target"
      return
    fi

    backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    backup_index=0
    while [[ -e $backup || -L $backup ]]; do
      ((backup_index += 1))
      backup="${target}.bak.$(date +%Y%m%d%H%M%S).${backup_index}"
    done
    if $dry_run; then
      printf 'Would back up: %s -> %s\n' "$target" "$backup"
    else
      printf 'Backing up: %s -> %s\n' "$target" "$backup"
    fi
    run mv "$target" "$backup"
  fi

  run mkdir -p "$parent"
  run ln -s "$source" "$target"
  if $dry_run; then
    printf 'Would link: %s -> %s\n' "$target" "$source"
  else
    printf 'Linked: %s -> %s\n' "$target" "$source"
  fi
}

install_target() {
  case $1 in
    profile)
      link_config "$script_dir/profile" "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/profile"
      printf 'Add this line to both shell rc files as needed:\n'
      printf '  source "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/profile/profile.sh"\n'
      ;;
    git)
      link_config "$script_dir/git/gitconfig" "$HOME/.gitconfig"
      link_config "$script_dir/git/gitignore_global" "$HOME/.gitignore_global"
      ;;
    maven)
      link_config "$script_dir/maven/settings.xml" "$HOME/.m2/settings.xml"
      link_config "$script_dir/maven/jvm.config" "$HOME/.m2/jvm.config"
      ;;
    gradle)
      link_config "$script_dir/gradle/init.gradle" "$HOME/.gradle/init.gradle"
      link_config "$script_dir/gradle/gradle.properties" "$HOME/.gradle/gradle.properties"
      ;;
    vim)
      link_config "$script_dir/vim/vimrc" "$HOME/.vimrc"
      ;;
    neovim)
      link_config "$script_dir/neovim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
      ;;
    tmux)
      link_config "$script_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
      link_config "$script_dir/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
      ;;
    vscode)
      case $(uname -s) in
        Darwin) vscode_dir="$HOME/Library/Application Support/Code/User" ;;
        Linux) vscode_dir="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User" ;;
        MINGW*|MSYS*|CYGWIN*) vscode_dir="${APPDATA:?APPDATA is required}/Code/User" ;;
        *) printf 'VS Code installation is not implemented for this platform.\n' >&2; return 1 ;;
      esac
      link_config "$script_dir/vscode/settings.json" "$vscode_dir/settings.json"
      link_config "$script_dir/vscode/keybindings.json" "$vscode_dir/keybindings.json"
      ;;
    opencode)
      link_config "$script_dir/opencode/AGENTS.md" "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/AGENTS.md"
      link_config "$script_dir/opencode/opencode.jsonc" "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/opencode.jsonc"
      ;;
    *)
      printf 'Unknown target: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

while (($#)); do
  case $1 in
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    all) targets=(profile git maven gradle vim neovim tmux vscode opencode) ;;
    *) targets+=("$1") ;;
  esac
  shift
done

if ((${#targets[@]} == 0)); then
  usage >&2
  exit 1
fi

for target in "${targets[@]}"; do
  install_target "$target"
done
