#!/bin/bash

#
## NOTE: This script relies on a working `xpath` command line tool. The one that ships with Mac OS X spews UI intermixed with the results, and swaps stdin/stderr so is unsuitable without modification. The tool this script was tested with was a modified version of the aforementioned broken one: messages to stderr, results to stdout.
#

set -e # Don't break...

cd # This script assumes $HOME.

mappingPlist=~/Library/Preferences/teh_test_map.plist
plutil -convert xml1 "$mappingPlist" #destructive

function justShow
{
	echo -e "LINK AT\t\t ~/$1 \tPOINTS TO\t\t $2."
}

function linkIt
{
	# cd `dirname $1` ###TODO:FIXME: 
	ln -fhsv "$2" ~/"$1"
	# -h	Don't follow existing links.
	if [ ! "." == "${1:0:1}" ]
	then
		SetFile -P -a V "$1"
	fi
	# Hide symlinks, if not already hidden.
}

if [ "show" == "$1" ]
then
	doIt=justShow
elif [ "link" == "$1" ]
then
	doIt=linkIt
fi

function applyOverwritePolicy ()
{
	local folderToBecomeLink="$1" \
		folderToHoldRealData="$2"

	if [ -L "$folderToBecomeLink" ]
	then
		: echo "Symlink '$folderToBecomeLink' will be overwirtten..." 1>&2 
	elif [ -d "$folderToBecomeLink" ]
	then
		if [ "linkIt" == "$doIt" ]
		then
				if [ -d "$(dirname "$folderToBecomeLink")"/"$folderToHoldRealData" ]
				then # merge and purge
					#deleteKnownUselessDataFrom: "$folderToBecomeLink"
					rsync -aEhxyz "$folderToBecomeLink"/ "$(dirname "$folderToBecomeLink")"/"$folderToHoldRealData"/ && \
					rm -Rfv "$folderToBecomeLink"
				else # rename # mv -vn
					rename "$folderToBecomeLink" "$(dirname "$folderToBecomeLink")"/"$folderToHoldRealData"
				fi
		else
			echo "Delete useless data from" "$folderToBecomeLink"
			echo "Replace " "$folderToHoldRealData"/ "with data from" "$folderToBecomeLink"/
			echo "Purge" "$folderToBecomeLink"/
		fi
	fi
}

IFS=$'\n' # Deal with spaces in symlink names.
for eachLink in `xpath "$mappingPlist" '/plist/dict/key' `
do
	symLink="$(PlistBuddy -c 'Print :'\""$eachLink"\" "$mappingPlist")"
	applyOverwritePolicy "$eachLink" "$symLink"
	${doIt:=justShow} "$eachLink" "$symLink"
done

