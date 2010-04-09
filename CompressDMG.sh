#!/bin/bash

import trash || return
    #del

set -e
set -x

oldDMG="$1"
scratch="$2"

DMGloc="$(dirname "$oldDMG")"

DMGtitle="$(basename "$oldDMG" .sparsebundle)"
DMGtitle="$(basename "$DMGtitle" .dmg)"
DMGtitle="$(basename "$DMGtitle" .sparseimage)"

scratchDMG="$scratch/$DMGtitle.dmg"
newDMG="$DMGloc/$DMGtitle.dmg"

hdiutil convert -format UDBZ -o "${scratchDMG}" "$oldDMG"
mv -v "${scratchDMG}" "${newDMG}-temp"
del "$oldDMG"
mv -v "${newDMG}-temp" "${newDMG}"
