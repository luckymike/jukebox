#!/bin/bash

cat << EOF | osascript -l AppleScript
set AppleScript's text item delimiters to {"||"}
tell application "iTunes"
get name of every track in playlist "$1" as Unicode text
end tell
EOF
