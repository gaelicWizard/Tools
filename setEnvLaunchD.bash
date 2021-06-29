#!/bin/bash

IFS=$'\n'
for tehEnv in $(~/Tools/xpath ~/.MacOSX/environment.plist '/plist/dict/key')
do
	launchctl setenv "$tehEnv" "$( /usr/libexec/PlistBuddy -c 'Print :'"$tehEnv" ~/.MacOSX/environment.plist )"
done
