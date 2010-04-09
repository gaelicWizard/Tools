#!/bin/sh

echo "$@" | exec perl -pi -e 's/%/%25/g;s/\$/%24/g;s/&/%26/g;s/\+/%2B/g;s/,/%2C/g;s:/:%2F:g;s/:/%3A/g;s/;/%3B/g;s/=/%3D/g;s/\?/%3F/g;s/@/%40/g'
