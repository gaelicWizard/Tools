#!/bin/sh

## This script is designed to replace the split(1) command line tool.
##
## Use at your own risk.
##
## Copyright 2006 John Davidorff Pell
## No rights reserved. This work may be treated as public domain

USAGE="see split(1)"

while getopts b:l:a: OPT
do
    case $OPT in
        b)
            BYTE_COUNT="$OPTARG"
            ;;
        l)
            LINE_COUNT="$OPTARG"
            ;;
        a)
            SUFFIX_LENGTH="$OPTARG"
            ;;
        *)
            echo "$USAGE"
            exit 1
            ;;
    esac
done
shift `expr $OPTIND - 1`
unset OPT OPTIND

FILE_TO_SPLIT="$1"
if [ "$FILE_TO_SPLIT" == "-" ] || [ ! "$FILE_TO_SPLIT" ] 
then
    FILE_TO_SPLIT=/dev/stdin
fi

FILE_SUFFIX_PREFIX="$2"

ALPHABET=( a b c d e f g h i j k l m n o p q r s t u v w x y z )
declare -a ALPHABET
ALPHACOUNTMAX=26
ALPHACOUNT=0
ALPHAPOP=0

exit -1

if [ "$BYTE_COUNT" ]
then
    while (( $BYTE_COUNT < $BYTES_COUNTED ))
    do
        OUT_FILE="$FILE_SUFFIX_PREFIX""${ALPHABET[$ALPHACOUNT]}"
        dd if="$FILE_TO_SPLIT" of="$OUT_FILE" count="$BYTE_COUNT" bs=1 skip="$BYTES_COUNTED"
        (( ALPHACOUNT++ ))
        if (( ALPHACOUNT >= 26 ))
        then
            ALPHACOUNT=0
            FILE_SUFFIX_PREFIX="$FILE_SUFFIX_PREFIX""${ALPHABET[$ALPHAPOP]}"
            (( ALPHAPOP++ ))
        fi
    done
fi


