jukebox
=======
Set of Scripts for an Arduino Controlled iTunes Based Jukebox

Required hardware
=================
Matrix keypad
RGB LCD Display and Adafruit LCD Shield
Coin Acceptor
Arduino

Required software
=================
serialport gem
Arduino Keypad library

Scripts
=======
jukebox.ino--Arduino code for physical jukebox interface:
Assigns credits based on coin input
Song selection via keypad
Displays # of credits and keypad entry via LCD

jukebox.rb--Ruby script to take Arduino serial output and set to iTunes
Listens for output from Arduino
Sends track number from Arduino to upnext.sh

upnext.sh--Applescript to add chosen tracks to playlist:
Selects tracks from numbered playlists (2 digits) based on track number
Adds selected tracks to a playlist called "jukebox"
