#!/bin/sh
echo '
exit2str(){
  case "$1" in'
"${BASH_SOURCE%/*}/exit.sh.sh" | sed -nEe's|^(S_)?EX_(([^_=]+_?)+)=([0-9]+).*|\4) echo "\1\2";;|p'
echo "
  esac
}"
