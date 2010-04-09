#!/bin/bash

set -e
    # Try to avoid data loss!

TMPDMGDIR="/Volumes/DroboMedia"

SOURCE="$1"
TARGETNAME="$(basename "$SOURCE" .sparsebundle).dmg"
TARGET="$TMPDMGDIR/$TARGETNAME"

hdiutil convert -format UDBZ -o "$TARGET" "$SOURCE"
hdiutil verify  "$TARGET"
echo "About to erase: $SOURCE"
for i in `seq 1 60`
do
    sleep 1
    echo -n .
done
echo ""
echo rm -vrf "$SOURCE"
echo -n "Moving... "
echo mv -vvv "$TARGET" "$(dirname "$SOURCE")/$TARGETNAME"
