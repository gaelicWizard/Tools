#!/bin/bash

IFS=$'\n'
for tehEnv in $(~/Tools/xpath ~/.MacOSX/environment.plist '/plist/dict/key')
do
	tehVal="$( /usr/libexec/PlistBuddy -c 'Print :'"$tehEnv" ~/.MacOSX/environment.plist )"
	launchctl setenv "$tehEnv" "${tehVal/#~/$HOME}"
done
