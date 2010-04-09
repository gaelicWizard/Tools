#!/bin/bash

require general || return # seq

for ThumbURL in "$@"
do
    BaseURL="${ThumbURL%.*x*-75.jpg}"
    # Loose the "thumb"-ness
    OutputFile="${BaseURL##*.}"

    echo "Starting ${ThumbURL}."

    for i in `seq 2048 100 -1`
    # Will try _every_ square resolution between 100x100 and 2000x2000, which will take a while.
    # Can't just try "rounded" numbers because larger resolutions may be 1453x1453.
    # Count _backwards_ down from largest resolution, so as to save time.
    do
        curl -f -s -o "${OutputFile}.jpg" "${BaseURL}.${i}x${i}-75.jpg" && break
        # Overwrite older downloads with newer ones.
        # Break as soon as the first file successfully downloads.
        sleep 0.1 # Throttle, which is even slower.
    done
done
