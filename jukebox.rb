#!/usr/local/bin/ruby

require "json"
require "serialport"

port_str = "/dev/cu.usbserial-A6006hSj"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

collection = JSON.parse(File.read("/tmp/collection.txt"))

while true do
  while (selection = sp.gets.chomp) do
    disc = selection[0..1]
    track = selection[2..3]
    chk_disc = disc.to_i-1
    chk_track = track.to_i-1
    unless collection[chk_disc].nil?
      unless collection[chk_disc][chk_track].nil?
        `./upnext.sh #{disc} #{track}`
      end
    end
  end
end

sp.close
