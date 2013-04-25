#!/usr/local/bin/ruby

require "serialport"

port_str = "/dev/cu.usbserial-A6006hSj"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

while true do
  while (i = sp.gets.chomp) do
    puts i
    d = i[0..1]
    t = i[2..3]
    `./upnext #{d} #{t}`
  end
end

sp.close
