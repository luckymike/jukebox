#!/usr/bin/env ruby

require "rubygems"
require "json"

selection = (ARGV[0])
collection = JSON.parse(File.read("/tmp/collection.txt"))

def validate_entry(entry, against)
  disc = entry[0..1]
  track = entry[2..3]
  if (disc == "00" || track == "00" || entry.include?("#") || entry.include?("*"))
    puts "invalid selection"
    validates = false
  else
    chk_disc = disc.to_i-1
    chk_track = track.to_i-1
    if against[chk_disc].nil?
      puts "disc not found"
      validates = false
    else
      if against[chk_disc][chk_track].nil?
        puts "track not found"
        validates = false
      else
        puts "added #{entry}"
        validates = true
        `./upnext.sh #{disc} #{track}`
        disc = nil
        track = nil
      end
    end
  end
  return validates
end

def itunes_status(status)
   (`osascript -e 'tell application "iTunes" to player state as string'`).gsub("\n","")==(status)
end

def itunes_play(playlist)
  `osascript -e 'tell application "iTunes"' -e 'set new_playlist to \"#{playlist}\" as string' -e 'play playlist new_playlist' -e 'end tell'`
end

if validate_entry(selection, collection)
  puts "valid selection"
  unless itunes_status("playing")
    itunes_play("Jukebox")
  end
else
  puts "invalid selection"
end
