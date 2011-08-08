#!/bin/bash

# from: http://pastie.org/2335679

for i in `fgrep .png *.xib */*.xib | egrep -o '[^>]+png' | sort | uniq` ; do 
    fgrep -q "$i" *.xcodeproj/project.pbxproj
    if [ ! $? -eq 0 ] ; then 
        echo " "
        echo "project does not include nib-referenced image: $i"
    fi
        
    if [ ! -e $i ] ; then 
        echo " "
        echo "missing nib-referenced image: $i"
        echo "referenced in:"
        fgrep -l "$i" *.xib */*.xib
    fi
done
