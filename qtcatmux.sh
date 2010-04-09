#!/bin/bash

# This file expects inputs created by HandBrakeCLI

TARGET="${1:-FELLOWSHIP_EXT}";  shift
SOURCE_A="${1:-FELLOWSHIP_EXT_D1.m4v}";shift
SOURCE_B="${1:-FELLOWSHIP_EXT_D2.m4v}";shift

TRACKS=( "$@" )

mkdir -p "$TARGET"

set -e
set -x

catmovie -force-same-tracks -o "${TARGET}/video only.mov" \
    "$SOURCE_A" -track "Video Track" -track "Text Track" \
    "$SOURCE_B" -track "Video Track" -track "Text Track"
    # Must -force-same-tracks in order for the chapter tracks to work.

for track in "${TRACKS[@]}"
do
    catmovie -force-same-tracks -o "${TARGET}/$track" \
        "$SOURCE_A" -track "$track" -track "Text Track" \
        "$SOURCE_B" -track "$track"
    
    # Must include the chapter track because the audio tracks are often a few hundredths of a second shorter than the video, but the chapter track is exactly the length of the video and by including it we avoid misaligned audio in the later portions of the movie.
    # Must -force-same-tracks in order for the alternative-audio switching to work, which must be enabled manually in QuickTime Pro (see below).
done

#catmovie -force-same-tracks -o "${TARGET}/main audio only.mov" \
#    "$SOURCE_A" -track "The Fellowship of the Ring" -track "Text Track" \
#    "$SOURCE_B" -track "The Fellowship of the Ring"
#catmovie -force-same-tracks -o "${TARGET}/director commentary only.mov" \
#    "$SOURCE_A" -track "Commentary by The Director and Writers" -track "Text Track" \
#    "$SOURCE_B" -track "Commentary by The Director and Writers"
#catmovie -force-same-tracks -o "${TARGET}/design commentary only.mov" \
#    "$SOURCE_A" -track "Commentary by The Design Team" -track "Text Track" \
#    "$SOURCE_B" -track "Commentary by The Design Team"
#catmovie -force-same-tracks -o "${TARGET}/production commentary only.mov" \
#    "$SOURCE_A" -track "Commentary by The Production/Post-Production Team" -track "Text Track" \
#    "$SOURCE_B" -track "Commentary by The Production/Post-Production Team"
#catmovie -force-same-tracks -o "${TARGET}/cast commentary only.mov" \
#    "$SOURCE_A" -track "Commentary by The Cast" -track "Text Track" \
#    "$SOURCE_B" -track "Commentary by The Cast"

pushd "$TARGET" && {
    muxmovie -notrack "Text Track" -o "without chapters.mov" \
        "video only.mov" -track "Video Track" -track "Text Track" \
        "${TRACKS[@]}"
        # DOES NOT WORK. The global -notrack "Text Track" is intended to remove the chapter track from each file, while the file-specific -track "Text Track" is intended to override this behaviour for just that one file.
    muxmovie -o "final ref.mov" "without chapters.mov" "video only.mov" -track "Text Track"
        # Re-mux the chapter track.
    
    popd
}

catmovie -self-contained -o "${TARGET}.mov" "${TARGET}/final ref.mov"

#muxmovie -o "${TARGET}/desplit.mov" \
#    "${TARGET}/video only.mov" \
#    "${TARGET}/main audio only.mov" -notrack "Text Track" \
#    "${TARGET}/director commentary only.mov" -notrack "Text Track" \
#    "${TARGET}/design commentary only.mov"  -notrack "Text Track" \
#    "${TARGET}/production commentary only.mov"  -notrack "Text Track" \
#    "${TARGET}/cast commentary only.mov"  -notrack "Text Track" 

echo "Make sure to set the audio tracks to alternative and enable the chapter track." 1>&2
open -a "QuickTime Player 7" "${TARGET}.mov"
