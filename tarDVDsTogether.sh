#!/bin/bash

set -e

TARGET="${1:-/dev/null}"; shift
SOURCE_PREFIX="${1:-/dev/null/file_does_not_exist}"
#TODO:FIXME: Should move the wildcard out into the shell, not here in the script.

tar cvf "$TARGET" ${SOURCE_PREFIX}*.dvdmedia/*.plist ${SOURCE_PREFIX}*.dvdmedia/Icon*

for i in $( ls -1 ${SOURCE_PREFIX}*.dvdmedia/VIDEO_TS | sort | uniq | grep -v dvdmedia )
do 
    tar rvf "$TARGET" ${SOURCE_PREFIX}*.dvdmedia/VIDEO_TS/"$i"
done

tar uvf "$TARGET" ${SOURCE_PREFIX}*.dvdmedia
