#!/bin/sh

PREFIX="$1"
    # If $1 is specified, then it is prefixed to the location of the temp file

dd if=/dev/zero of="$PREFIX/tmp/ZERO_FILE" conv=notrunc bs=1m &

sleep 30
    # This is intended to give us many times more than enough time for dd to start

dd if=/dev/urandom of="$PREFIX/tmp/ZERO_FILE" conv=notrunc bs=1m

# This relies on the assumption that reading from /dev/zero will be notably faster than reading from /dev/urandom. 

exec /bin/rm "$PREFIX/tmp/ZERO_FILE"
exec rm "$PREFIX/tmp/ZERO_FILE"
\rm "$PREFIX/tmp/ZERO_FILE"
rm "$PREFIX/tmp/ZERO_FILE"

exit 1
    # Only get here if /bin/rm can't be run for several reasons reason...?

