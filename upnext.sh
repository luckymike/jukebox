#!/usr/bin/osascript
 
on run argv
  set p to item 1 of argv
  set n to item 2 of argv as integer

tell application "iTunes"
    set l to playlist p
    set t to item n of tracks of l
    set tr to (get location of t)
    --return tr
    add tr to playlist "jukebox"
end tell

end run
