# Shared entry point for Bash and Zsh.
if [[ -n ${BASH_VERSION:-} ]]; then
  _mymacprofile_source=${BASH_SOURCE[0]}
elif [[ -n ${ZSH_VERSION:-} ]]; then
  _mymacprofile_source=${(%):-%x}
else
  _mymacprofile_source=$0
fi

_mymacprofile_dir=$(cd "$(dirname "$_mymacprofile_source")" && pwd -P)

# shellcheck source=common.sh
source "$_mymacprofile_dir/common.sh"

if [[ -n ${BASH_VERSION:-} ]]; then
  # shellcheck source=bash.sh
  source "$_mymacprofile_dir/bash.sh"
elif [[ -n ${ZSH_VERSION:-} ]]; then
  # shellcheck source=zsh.sh
  source "$_mymacprofile_dir/zsh.sh"
fi

case $(uname -s) in
  Linux)
    # shellcheck source=platform/linux.sh
    source "$_mymacprofile_dir/platform/linux.sh"
    ;;
  Darwin)
    # shellcheck source=platform/macos.sh
    source "$_mymacprofile_dir/platform/macos.sh"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    # shellcheck source=platform/windows.sh
    source "$_mymacprofile_dir/platform/windows.sh"
    ;;
esac

# shellcheck source=bashfunc.sh
source "$_mymacprofile_dir/bashfunc.sh"

_mymacprofile_local=${MYMACPROFILE_LOCAL:-${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/local.sh}
if [[ -r $_mymacprofile_local ]]; then
  # shellcheck disable=SC1090
  source "$_mymacprofile_local"
fi

unset _mymacprofile_source _mymacprofile_dir _mymacprofile_local
