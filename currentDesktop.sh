#!/bin/sh

echo -n "Current Desktop Picture is "
echo `defaults read com.apple.desktop Background | grep LastName | awk '{print $3}'`
#echo `osascript -e 'tell application "Finder" to return POSIX path of (desktop picture as alias)'`
