#!/bin/bash

IFS=$'\n'
for tehEnv in $(~/Tools/xpath ~/.MacOSX/environment.plist '/plist/dict/key')
do
    tehVal="$( /usr/libexec/PlistBuddy -c 'Print :'"$tehEnv" ~/.MacOSX/environment.plist | perl -pe 's/\$(\w+)/$ENV{$1}/g' )"
    launchctl setenv "$tehEnv" "${tehVal/#~/$HOME}"
done
