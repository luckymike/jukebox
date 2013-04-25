#!/usr/local/bin/ruby

require "serialport"

port_str = "/dev/cu.usbserial-A6006hSj"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

while true do
  while (selection = sp.gets.chomp) do
    disk = selection[0..1]
    track = selection[2..3]
    `./upnext.sh #{disk} #{track}`
  end
end

sp.close
