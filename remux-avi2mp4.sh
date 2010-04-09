#!/bin/bash --login

set -e
    # Don't fail.

import trash || return -1
    # Import my trash package for
        # del

INPUT="${1:-/dev/null}"
AUDIO="${INPUT%.*}.mp3" # just assume its mp3-in-avi
#AUDIOWAV="${INPUT%.*}.wav"
#NEWAUDIO="${INPUT%.*}.aac"
VIDEO="${INPUT%.*}.h264" # just assume its h264-in-avi (sometimes it lies and claims to be avc1, which it's not.
OUTPUT="${INPUT%.*}.m4v"

EXTMPLAYER="$HOME/.Trash/MPlayer OSX Extended.app/Contents/Resources/External_Binaries/mplayer-mt.app/Contents/MacOS"
if test -e "$EXTMPLAYER/mplayer"
then
    PATH="$PATH":"$EXTMPLAYER"
fi

if test -e /opt/local/bin/mp4creator
then
    PATH="$PATH":/opt/local/bin
fi

echo demuxing...
#mplayer "$INPUT" -vc null -vo null -ao pcm:file="$AUDIOWAV":fast
VIDEO_CODEC_WITH_BRACKETS="$(mplayer "$INPUT" -dumpaudio -dumpfile "$AUDIO" | awk '/^VIDEO/ {print $2}')"
VIDEO_CODEC_WITH_END_BRACKET="${VIDEO_CODEC_WITH_BRACKETS:1:99}" 
VIDEO_CODEC="${VIDEO_CODEC_WITH_END_BRACKET:0:$(( ${#VIDEO_CODEC_WITH_END_BRACKET} - 1 ))}"
#VIDEO="${VIDEO}.${VIDEO_CODEC}"
# strip the first and last character to go from 6 to 4 characters
    # Cleverly try to guess the video codec, but sadly really we just need the h264 stream to be honest about being an h264 stream and not an avc1 stream.

RATE="$(mplayer "$INPUT" -dumpvideo -dumpfile "$VIDEO" | awk '/^VIDEO/ {print $5}')"

echo encoding...
#faac -r -o "$NEWAUDIO" "$AUDIOWAV" 
afconvert -v "$AUDIO" -o "$OUTPUT" --file "mp4f"
    # Slowest step, so print progress (-v)

echo muxing...
#mp4creator -create="$NEWAUDIO" "$OUTPUT"
mp4creator -create="$VIDEO" -rate="$RATE" "$OUTPUT"

echo done.
mp4creator -list "$OUTPUT"

del "$AUDIO" "$VIDEO" # "$AUDIOWAV" "$NEWAUDIO"
