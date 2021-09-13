#!/bin/sh
#
set -ex

TEMP_DIR="$(mktemp -d -t XXXX)"
# cleanup
trap 'RESULT=$?; rm -rf "$TEMP_DIR" ; exit $RESULT' INT TERM EXIT QUIT

OLD_PWD="$PWD"
cd "$TEMP_DIR"
RESULT_DIR='linux_manpages'
RESULT_DIR_ABSOLUTE="$TEMP_DIR/$RESULT_DIR"

copy_manpages() {
  TARGET="$1"
  
  mkdir -p "$TARGET"
  manpath | tr ':' "\n" | while read -r MANDIR; do
     set -x
     cd "$MANDIR"
     MANDIR_UNDERSCORED="$(echo "$MANDIR" | tr '/' '_')"
     # -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
     ( set +e 
       if [ -z "$TARGET" ]; then
         echo "missing TARGET" >&2
         exit 1
       fi
       rsync -a --no-l --no-p --no-t --no-g --no-o --no-D -vL -- man* "$TARGET/$MANDIR_UNDERSCORED"/ >&2
       RESULT="$?"
       case "$RESULT" in
         0|23) exit 0 ;; # success
         *) exit 1 ;; # failure
       esac
     )
  done
}

copy_manpages "$RESULT_DIR_ABSOLUTE"

if [ "$1" = '-' ]; then
  tar zc "$RESULT_DIR"
else
  MANPAGES_TARBALL="$OLD_PWD/linux_manpages.tar.gz"
  MANPAGES_TARBALL_TEMP="${MANPAGES_TARBALL}.tmp"
  
  trap 'RESULT=$?; rm -rf "$MANPAGES_TARBALL_TEMP" "$TEMP_DIR" ; exit $RESULT' INT TERM EXIT QUIT
  tar zcvf "$MANPAGES_TARBALL_TEMP" "$RESULT_DIR"
  mv "$MANPAGES_TARBALL_TEMP" "$MANPAGES_TARBALL"
fi