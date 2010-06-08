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
BASENAME="${INPUT%%.*}"
OUTPUT="${BASENAME}.mp4"
AUDIO_CODEC="copy" # default to no-re-encode. (Video is never re-encoded.)
TEMP_VIDEO="${BASENAME}.h264"
TEMP_AUDIO="${BASENAME}.aac"

bashd_add_to_path_front /opt/local/bin # MacPorts
bashd_add_to_path_front ~/Projects/ffmpeg-x86_64.bundle/Contents/Tools

VIDEO_FORMAT="$(ffmpeg -i "$INPUT" 2>&1 | awk -F '[:, ]' '/^    Stream #.*: Video/ {print $10}')"
AUDIO_FORMAT="$(ffmpeg -i "$INPUT" 2>&1 | awk -F '[:, ]' '/^    Stream #.*: Audio/ {print $10}')"

if [ ! x"$VIDEO_FORMAT" == x"h264" ]
then
    # We'll need to convert some stuff.
    echo "Needs conversion: Video@ $VIDEO_FORMAT, Audio@ $AUDIO_FORMAT."
    exit 1
else
    FRAME_RATE="$(ffmpeg -y -i "$INPUT" -vcodec copy -an "$TEMP_VIDEO" 2>&1 | awk -F '[:, ]' '/^    Stream #.*: Video: h264.*tbr/ {print $16}')"
        # Frame rate must be manually specified for mp4creator(1).
fi

if [ ! x"$AUDIO_FORMAT" == x"aac" ]
then
    echo "Converting audio to AAC from $AUDIO_FORMAT."
    AUDIO_CODEC=libfaac # AAC encoded by libFAAC # low quality…
fi

ffmpeg -y -i "$INPUT" -acodec "$AUDIO_CODEC" "$TEMP_AUDIO"

mp4creator -create="$TEMP_VIDEO" -r "$FRAME_RATE" "$OUTPUT"
mp4creator -create="$TEMP_AUDIO" "$OUTPUT"
del "$TEMP_VIDEO" "$TEMP_AUDIO"
    # Delete the temp files. 


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
