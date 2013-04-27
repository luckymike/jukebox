jukebox
=======
Set of Scripts for an Arduino Controlled iTunes Based Jukebox

Required hardware
=================
* Matrix keypad
* RGB LCD Display and Adafruit LCD Shield
* Coin Acceptor
* Arduino

Required software
=================
* serialport gem
* Arduino Keypad library

Scripts
=======
jukebox.ino--Arduino code for physical jukebox interface:
* Assigns credits based on coin input (To-Do)
* Song selection via keypad
* Displays # of credits and keypad entry via LCD (To-Do)
* Displays currently playing track # if no credits (To-Do)

jukebox.rb--Ruby script to take Arduino serial output and set to iTunes:
* Listens for output from Arduino
* Validates disc and track
* Sends track # from Arduino to upnext.sh
* Sends "Now Playing" track # to Arduino for display

collection.rb--Ruby script that builds an array of all available tracks for validation:
* Takes a single argument: last disc number
* Saves json array to /tmp/collection.rb

upnext.sh--Applescript to add chosen tracks to playlist:
* Selects tracks from numbered playlists (2 digits) based on track number
* Adds selected tracks to a playlist called "jukebox"

manual.rb--Ruby script to test track validation and selection:
* Takes a single argument: track number (4 digits)
* Validates disc and track
* Sends track # from Arduino to upnext.sh
