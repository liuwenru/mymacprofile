#!/usr/bin/env bash

set -eu
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

case $(uname -s) in
  Darwin) vscode_dir="$HOME/Library/Application Support/Code/User" ;;
  Linux) vscode_dir="${XDG_CONFIG_HOME:-$HOME/.config}/Code/User" ;;
  MINGW*|MSYS*|CYGWIN*) vscode_dir="${APPDATA:?APPDATA is required}/Code/User" ;;
  *) printf 'VS Code export is not implemented for this platform.\n' >&2; exit 1 ;;
esac

settings_source="$vscode_dir/settings.json"
keybindings_source="$vscode_dir/keybindings.json"
settings_target="$script_dir/settings.json"
keybindings_target="$script_dir/keybindings.json"

if [[ ! -f $settings_source || ! -f $keybindings_source ]]; then
  printf 'Both VS Code settings.json and keybindings.json are required.\n' >&2
  exit 1
fi

settings_tmp=
keybindings_tmp=
trap 'rm -f "${settings_tmp:-}" "${keybindings_tmp:-}"' EXIT

if [[ $settings_source -ef $settings_target ]]; then
  printf 'Already tracked: %s\n' "$settings_source"
else
  settings_tmp=$(mktemp "$script_dir/.settings.json.XXXXXX")
  cp "$settings_source" "$settings_tmp"
fi

if [[ $keybindings_source -ef $keybindings_target ]]; then
  printf 'Already tracked: %s\n' "$keybindings_source"
else
  keybindings_tmp=$(mktemp "$script_dir/.keybindings.json.XXXXXX")
  cp "$keybindings_source" "$keybindings_tmp"
fi

if [[ -n $settings_tmp ]]; then
  mv "$settings_tmp" "$settings_target"
  settings_tmp=
  printf 'Exported: %s\n' "$settings_target"
fi

if [[ -n $keybindings_tmp ]]; then
  mv "$keybindings_tmp" "$keybindings_target"
  keybindings_tmp=
  printf 'Exported: %s\n' "$keybindings_target"
fi
