#!/bin/bash

IFS=$'\n'
for tehEnv in $(~/Tools/xpath /plist/dict/key ~/.MacOSX/environment.plist)
do
	launchctl setenv "$tehEnv" "$( /usr/libexec/PlistBuddy -c 'Print :'"$tehEnv" ~/.MacOSX/environment.plist )"
done
