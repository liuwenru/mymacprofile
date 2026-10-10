#!/usr/bin/env bash

# Compatibility entry point for existing ~/.bashrc and ~/.zshrc files.
if [[ -n ${BASH_VERSION:-} ]]; then
  _mymacprofile_source=${BASH_SOURCE[0]}
elif [[ -n ${ZSH_VERSION:-} ]]; then
  _mymacprofile_source=${(%):-%x}
else
  _mymacprofile_source=$0
fi

_mymacprofile_dir=$(cd "$(dirname "$_mymacprofile_source")" && pwd -P)
# shellcheck source=profile.sh
source "$_mymacprofile_dir/profile.sh"
unset _mymacprofile_source _mymacprofile_dir
