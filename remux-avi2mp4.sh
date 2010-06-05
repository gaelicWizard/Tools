#!/bin/bash --login

set -e
    # Don't fail.

import trash || return -1
    # Import my trash package for
        # del
import path || return -1
    # Import my path package for
        # bashd_add_to_path_front

INPUT="${1:-/dev/null}"
OUTPUT="${INPUT%%.*}.mp4"

bashd_add_to_path_front ~/Projects/ffmpeg-x86_64.bundle/Contents/Tools

VIDEO_FORMAT="$(ffplay -nodisp -an -vn -stats "$INPUT" 2>&1 | awk -F '[:, ]' '/^    Stream #...: Video/ {print $10}')"
AUDIO_FORMAT="$(ffplay -nodisp -an -vn -stats "$INPUT" 2>&1 | awk -F '[:, ]' '/^    Stream #...: Audio/ {print $10}')"

if [ ! x"$VIDEO_FORMAT" == x"h264" ] || [ ! x"$AUDIO_FORMAT" == x"aac" ]
then
    # We'll need to convert some stuff.
    echo "Needs conversion: Video@ $VIDEO_FORMAT, Audio@ $AUDIO_FORMAT."
    exit 1
fi

ffmpeg -vcodec copy -acodec copy -i "$INPUT" "$OUTPUT"


#/opt/local/lib/libdirac_decoder.0.dylib is provided by: dirac
#/opt/local/lib/libdirac_encoder.0.dylib is provided by: dirac
#/opt/local/lib/libfaac.0.dylib is provided by: faac
#/opt/local/lib/libfaad.2.dylib is provided by: faad2
#/opt/local/lib/libmp3lame.0.dylib is provided by: lame
#/opt/local/lib/libschroedinger-1.0.0.dylib is provided by: schroedinger
#/opt/local/lib/liboil-0.3.0.dylib is provided by: liboil
#/opt/local/lib/libtheora.0.dylib is provided by: libtheora
#/opt/local/lib/libogg.0.dylib is provided by: libogg
#/opt/local/lib/libvorbisenc.2.dylib is provided by: libvorbis
#/opt/local/lib/libvorbis.0.dylib is provided by: libvorbis
#/opt/local/lib/libx264.70.dylib is provided by: x264
