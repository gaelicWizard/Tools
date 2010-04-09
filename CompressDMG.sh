#!/bin/bash

set -e
set -x

# This script assumes that oldDMG is at the root of its volume

oldDMG="$1"
scratch="$2"

DMGloc="$(dirname "$oldDMG")"
DMGlocTrash="$DMGloc/.Trashes/$UID"

DMGtitle="$(basename "$oldDMG" .sparsebundle)"
DMGtitle="$(basename "$DMGtitle" .dmg)"
DMGtitle="$(basename "$DMGtitle" .sparseimage)"

scratchDMG="$scratch/$DMGtitle.dmg"
newDMG="$DMGloc/$DMGtitle.dmg"

hdiutil convert -format UDBZ -o "${scratchDMG}" "$oldDMG"
mv -v "${scratchDMG}" "$newDMG"
mkdir -p "${DMGlocTrash}/"
mv -v "$oldDMG" "${DMGlocTrash}/"
