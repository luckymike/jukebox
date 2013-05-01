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
was_playing = String.new

while true do
  if (selection = sp.gets.chomp)
    disc = selection[0..1]
    track = selection[2..3]
    if (disc == "00" || track == "00")
      puts "invalid selection"
      sp.write("n")
    else
      chk_disc = disc.to_i-1
      chk_track = track.to_i-1
      if collection[chk_disc].nil?
        puts "disc not found"
        sp.write("n")
      else
        if collection[chk_disc][chk_track].nil?
          puts "track not found"
          sp.write("n")
        else
          puts "playing #{selection}"
          sp.write("y")
          `./upnext.sh #{disc} #{track}`
        end
      end
    end
  else
    playing = (`osascript -e 'tell application "iTunes" to name of current track as string'`).gsub("\n","")

    disc = collection.index(collection.detect { |d| d.include?(playing) })
    track = collection[disc].index(playing)
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
    now_playing = disc + track
    while now_playing != was_playing
      sp.write(now_playing)
      puts "Now Playing: #{now_playing}"
      was_playing = now_playing
    end
  end
end
sp.close
