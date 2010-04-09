#!/bin/bash

# This script might rely on some bash-isms. Deal with it.

while getopts "0Scimsl:d" options
do
    case $options in
        0) 
            MDFIND_ARGS="$MDFIND_ARGS -0"
            shift
            ;;
        S)
            exec mdutil -s -a
            shift
            ;;
        c)
            MDFIND_ARGS="$MDFIND_ARGS -count"
            shift
            ;;
        i)
            IGNORE_CASE=TRUE
            shift
            echo "Case insensitivity is not yet supported." 1>&2
            ;;
        m)
            # Silently ignore -m
            shift
            ;;
        s)
            # Silently ignore -s
            shift
            ;;
        l)
            PRINT_FIRST_LINES="$OPTARG"
            shift
            ;;
        d)
            shift
            echo "This version of locate can only use the Spotlight database." 1>&2
            exit 1
            ;;
        *)
            shift
            echo "Usage: locate [-0Scims] [-l limit] pattern ..."
            exit 1
            ;;
    esac    
done

function mdfind_search_list
{
    j="$#"
    for i in "$@"
    do
        LIST="${LIST}kMDItemFSName == '*${i}*'"
        if [ "$j" -gt 1 ]
        then
            j=$((j-1))
            LIST="$LIST || "
        fi
    done
    echo "$LIST"
}

if [ "$PRINT_FIRST_LINES" ]
then
    exec mdfind $MDFIND_ARGS "$(mdfind_search_list "$@")" | head -n $PRINT_FIRST_LINES
else
    exec mdfind $MDFIND_ARGS "$(mdfind_search_list "$@")"
fi

exit 9
    # This should never happen. 
