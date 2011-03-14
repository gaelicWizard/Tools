#!/bin/bash

if [ "$#" -lt 2 ]
then
    echo "$(basename "$0") requires two or more arguments: 1) [user]@hostname, 2*) command [args]." 1>&2
    exit -1
fi

where="$1"; shift

exec "${SSH:-ssh}" "$where" exec /bin/bash --login -c "'$*'"
