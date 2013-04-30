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
selection = (`osascript -e 'tell application "iTunes" to name of current track as string'`).gsub("\n","")

disc = collection.index(collection.detect { |d| d.include?(selection) })
track = collection[disc].index(selection)
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
sp.write(now_playing)

