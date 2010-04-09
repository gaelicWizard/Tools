#!/bin/bash -l

set -e

require trash || return 1

nice -n 1 rsync -ahv -E --inplace --progress --cvs-exclude "$@" armitage:Movies/Drop/
    # Don't enable compression b/c ssh does compression itself.
    # -E / --extended-attributes (incl. resource fork)
    # --inplace implies --resume, which speeds up my usage (since I'm almost universally just copying files one-way and I just want --resume anyway).
    # --cvs-exclude imports ~/.cvsignore (and some defaults) for excludes

trash "$@"
