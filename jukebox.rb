#!/usr/bin/env ruby

require "rubygems"
require "json"
require "serialport"

port_str = "/dev/cu.usbserial-A6006hSj"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

collection = JSON.parse(File.read("/tmp/collection.txt"))

last_entry = "0000"

def now_playing(against)
  playing = (`osascript -e 'tell application "iTunes" to name of current track as string'`).gsub("\n","")
  disc = against.index(against.detect { |d| d.include?(playing) })
  track = against[disc].index(playing)
  disc = disc + 1
  if disc < 10
    disc = "0" + disc.to_s
  else
    disc = disc.to_s
  end
  track = track + 1
  if track < 10
    track = "0" + track.to_s
  else
    track = track.to_s
  end
  current_track = disc + track
  puts current_track
  return current_track
end

def validate_entry(entry, against, last)
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
        unless entry == last
          `./upnext.sh #{disc} #{track}`
        end
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

while true do
  while (selection = sp.gets.chomp)
    if selection == "done"
      case itunes_status("playing")
      when true
        sp.write(now_playing(collection))
      when false
        itunes_play("Jukebox")
      end
    else
      if validate_entry(selection, collection, last_entry)
        sp.write("y")
        last_entry = selection
      else
        sp.write("n")
      end
    end
  end
end

sp.close
