#!/bin/bash

for i in "$@"
do
    curl -O "http://cdn-2.nflximg.com/us/boxshots/ghd/${i}.jpg"
done
