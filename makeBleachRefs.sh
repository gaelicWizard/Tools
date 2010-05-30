#!/bin/bash

set -e
    # Be strict

INCLUDE_TRACKS=( -track "Video Track" -track Stereo -track English -track "English Dub" )
    # Unless named, all languages will be named Stereo, and there's no easy way to filter.
SKIP_CHAPTERS=( -nochapter Opening -nochapter "Opening   " -nochapter Closing -nochapter "Closing   " )

for i in `seq 1 11` `seq 14 22`
    # I failed to encode Volumes 12, 13, & 14 with chapter markers, so they must be done seperately.
    # I've made the executive decision to pretend that the first movie is part of season 5 (for iTunes, but not here), so it has to be excluded here by only including disks 23 thru 26.
do
    catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" "${SKIP_CHAPTERS[@]}" -o "Bleach: Volume $i".mov \
        /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season*/$i-*.m4v
done

catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" -o "1 The Substitute.mov" "${SKIP_CHAPTERS[@]}" \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 1/* "$@"
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" -o "2 The Entry.mov" "${SKIP_CHAPTERS[@]}" \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 2/[6789]* \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 2/10-0* "$@"
    # 10 sorts before 1-, so manually list 10 at the end.
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" -o "3 The Rescue.mov" "${SKIP_CHAPTERS[@]}" \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/11* \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-01*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.1 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-02*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-03*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/12-04*.m4v -startAt 00:01:25.0 -trimTo 00:20:02.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-01*.m4v -startAt 00:01:25.0 -trimTo 00:20:01.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-02*.m4v -startAt 00:01:25.0 -trimTo 00:20:01.5 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-03*.m4v -startAt 00:01:30.0 -trimTo 00:20:51.0 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/13-04*.m4v -startAt 00:01:30.0 -trimTo 00:20:53.0 \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 3/1[45]* "$@"
    # For some unknown reason, several episodes lack chapter markers...
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" -o "4 The Bount.mov" "${SKIP_CHAPTERS[@]}" \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 4/* "$@"
catmovie -auto-chapters -force-same-tracks "${INCLUDE_TRACKS[@]}" -o "5 The Assault.mov" "${SKIP_CHAPTERS[@]}" \
    /Volumes/DroboMedia/iTunes\ Media/TV\ Shows/Bleach/Season\ 5/2[3456]* "$@"
    # I've made the executive decision to pretend that the first movie is part of season 5 (for iTunes, but not here), so it has to be excluded here by only including disks 23 thru 26.

echo "Now, the files need to be edited so that the titles are per-season, and not just the first episode." 1>&2
