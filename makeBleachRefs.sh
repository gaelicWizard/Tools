#!/bin/bash

#function catmovie { echo "catmovie $@"; } # debug

set -e
    # Be strict

INCLUDE_TRACKS=( -track "Video Track" -track Stereo -track English -track "English Dub" )
    # Unless named, all languages will be named Stereo, and there's no easy way to filter.
SKIP_CHAPTERS=( -nochapter Opening -nochapter "Opening   " -nochapter Closing -nochapter "Closing   " )

for i in `jot - 3 11` `jot - 14 26`
    # I failed to encode Volumes 12 & 13 with chapter markers, so they must be done separately.
    # Since I've made the executive decision to put the Bleach movies in with the TV Show, I need to separate discs 1 and 2 as well.
do
    catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume $i".mov \
        /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season*/$i-*.m4v \
        "$@"
done

catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume 1".mov \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 1/1-*.m4v \
    "$@"
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume 2".mov \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 1/2-*.m4v \
    "$@"

catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume 12".mov \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-01*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.1 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-02*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-03*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-04*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    "$@"
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume 13".mov \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-01*.m4v -startAt 00:01:25.0 -trimTo 00:20:01.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-02*.m4v -startAt 00:01:25.0 -trimTo 00:20:01.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-03*.m4v -startAt 00:01:30.0 -trimTo 00:20:51.0 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-04*.m4v -startAt 00:01:30.0 -trimTo 00:20:53.0 \
    "$@"
    # For some unknown reason, several episodes lack chapter markers...

echo "Now, the files need to be edited so that the titles are per-season, and not just the first episode." 1>&2
