#!/bin/bash

###
## autolaunch.sh
# This script will go through the list of apps set to be auto-launched at login via the Users/Accounts Preference Pane. For each item in the list, a launchd(1) job will be submitted which keeps the app running indefinitely. It does so through the use of LaunchServices (via the open(1) command), so as to avoid launching duplicate instances of an app.
# BUG: Many apps come to the foreground despite --background. 
###

set -e

action="${1:-start}"; shift

function error { echo "'$action' requires an argument: ${1}." 1>&2; }

export TMPDIR="${TMPDIR:=/tmp}" # Should be /var/folders/{xx}/{xxxx...xxxx}/T/
export PATH="~/Tools:$PATH"

binaryAutolaunchPlist=~/Library/Preferences/com.apple.loginitems.plist # Historically .../loginwindow.plist
autolaunchPlist="${TMPDIR}/loginitems.plist"

cp "$binaryAutolaunchPlist" "$autolaunchPlist"
plutil -convert xml1 "$autolaunchPlist"

case $action in
    start | stop | read )
        TMPIFS="$IFS"; IFS=$'\n' # To deal with the results of xpath. 

        declare -a autoApps
        for appAlias in $(
            xpath "$autolaunchPlist" '/plist/dict/key[.="SessionItems"]/following-sibling::dict/key[.="CustomListItems"]/following-sibling::array/dict/key[.="Alias"]/following-sibling::data/text()' #2>/dev/null
            )
# '/plist/dict/key[.="AutoLaunchedApplicationDictionary"]/following-sibling::array/dict/key[.="Path"]/following-sibling::string/text()'
        do
			appPath=
            appLabel="$(
                PlistBuddy -c 'Print CFBundleIdentifier' "$appPath"/Contents/Info.plist
                ).keepAlive"
            if [ "read" == "${action}" ]
            then
                echo "$appLabel" 1>&2
                echo "$appPath"  1>&2
            else # to defeat SEE's broken syntax highlighting
            if [ "start" == "${action}" ]
            then
                (set -x; exec \
                    launchctl submit \
                            -l "$appLabel" \
                            -- \
                        open --wait-apps --hide --background -a "$appPath"
                )
            else
                (set -x; exec \
                    launchctl remove "$appLabel"
                )
            fi
            fi # to defeat SEE's broken syntax highlighting
        done
        IFS="$TMPIFS"
        ;;
    list )
        osascript -e 'tell application "System Events" to get the name of every login item'
        ;;
    add )
        if [ -d "$1/Contents/MacOS" ]
        then
            osascript -e 'tell application "System Events" to make login item at end with properties {path:"'"$1"'", hidden:'"${2:-false}"'}' 
        else
            error "path of app to add"
        fi
        ;;
    remove )
        if [ -n "$1" ]
        then
            osascript -e 'tell application "System Events" to delete login item "'"$1"'"' 
        else
            error "name of app to remove"
        fi
        ;;
esac
