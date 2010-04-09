#!/bin/bash

set -e
HERE="$(dirname "$0")"


CHAPTER_IN_ONE="$(mktemp /tmp/XXXXXXX)"
CHAPTER_IN_TWO="$(mktemp /tmp/XXXXXXX)"
CHAPTER_OUT="$(mktemp /tmp/XXXXXXX)"

cp -v "$1" "$CHAPTER_IN_ONE"
cp -v "$2" "$CHAPTER_IN_TWO"

perl -pi -e 's/\r\n/\n/g;s/\r/\n/g' "$CHAPTER_IN_ONE"
perl -pi -e 's/\r\n/\n/g;s/\r/\n/g' "$CHAPTER_IN_TWO"

cp "$CHAPTER_IN_ONE" "$CHAPTER_OUT"

TIME_TO_ADD="$(tail -n 1 "$CHAPTER_IN_ONE")"

IFS='
'

j=0
for i in $(cat < $CHAPTER_IN_TWO);
do
    if [ "$(echo "$i" | cut -c 1)" == '[' ]
    then
        "$HERE"/add_time.sh "$i" "$TIME_TO_ADD" >> "$CHAPTER_OUT"
    elif (echo "$i" | fgrep Chapter >/dev/null 2>&1)
    then
        j=$(( $j + 1 ))
        echo 'Chapter B'$j >> "$CHAPTER_OUT"
    else
        ( echo "$i" | fgrep -v QTtext >> "$CHAPTER_OUT" ) || true
    fi
done

perl -pi -e 's/\r\n/\n/g;s/\n/\r/g' "$CHAPTER_OUT"

perl -pi -e 's/{textEncoding:256}//g' "$CHAPTER_OUT"

#filter for unique lines

echo "$CHAPTER_OUT"
