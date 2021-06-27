#!/bin/sh

if [ -e "$1" ]
then
    cp -v -- "$@" ~/Backups/"$1 $(date).bak"
else
    echo "$0 requires an argument."
fi
