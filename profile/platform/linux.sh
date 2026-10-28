# Environment variables for Linux live in profile/env.sh.
unset TMOUT

alias dockerimages='docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>"'
