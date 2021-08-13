#!/bin/sh
#
# Generate a shell equivalent to <sysexits.h>

if [[ -r "${src:=/usr/include/sysexits.h}" ]]
then : "${src}"
elif [[ -d "${sdk:=$(xcrun --show-sdk-path)}" ]]
then : "${sdk}${src}"
	src="${sdk}${src}"
fi

echo "# Generated from \"$src\"" 
echo "# Please inspect the source file for more detailed descriptions"
echo
perl -nE 'print if s/^#define\s+(\w+)\s+(\d+).*$/\1=\2/p' "$src"

cat<<'EOF'

#System errors
S_EX_ANY=1  #Catchall for general errors
S_EX_SH=2   #Misuse of shell builtins (according to Bash documentation); seldom seen
S_EX_EXEC=126   #Command invoked cannot execute     Permission problem or command is not an executable
S_EX_NOENT=127  #"command not found"    illegal_command Possible problem with $PATH or a typo
S_EX_INVAL=128  #Invalid argument to exit   exit 3.14159    exit takes only integer args in the range 0 - 255 (see first footnote)
#128+n  Fatal error signal "n"  kill -9 $PPID of script $? returns 137 (128 + 9)
#255*   Exit status out of range    exit -1 exit takes only integer args in the range 0 - 255
EOF
$(type -P kill) -l |tr ' ' '\n'| awk '{ printf "S_EX_%s=%s\n", $0, 128+NR; }'
