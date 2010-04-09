#!/bin/sh

set -- `cscreen -v | head -n 3 | tail -n 1 | awk '{print $3 " " $4}'` 

cscreen -d 32 -x $1 -y $2
