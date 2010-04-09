#!/bin/sh

cd

BU=Backups/nixup

i=1

while [ -f "${HOME}/${BU}${i}.tbz2" ]
do
    ((i++))
done

tar cvfj ~/"${BU}${i}.tbz2" .bash* .rc* .*rc .[Xx]* .ssh .*macs .MacOSX Tools
