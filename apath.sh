#!/bin/sh

# Usage display
if [ $# -eq 0 ]; then
  cat << EOF
Usage: ${0} alias
  where alias is an alias file.
  Returns the file path to the original file referenced by a
  Mac OS X GUI alias. Use it to execute commands on the
  referenced file. For example, if aliasd is an alias of
  a directory, entering
    % cd \`${0} alias\`
  at the command line prompt would change the working directory
  to the original directory.
EOF

# Main routine
# If it's a file and not a link, we continue
elif [ -f "$1" -a ! -L "$1" ]; then
  # Run the AppleScript to decode the alias.
  osascript << EOF
    tell application "Finder"
      set theItem to (POSIX file "${1}") as alias
      if the kind of theItem is "alias" then
        get the posix path of ((original item of theItem) as text)
      end if
    end tell
EOF
fi
