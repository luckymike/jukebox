#!/usr/bin/env ruby

rquire "rubygems"
require "json"

selection = (ARGV[0])
collection = JSON.parse(File.read("/tmp/collection.txt"))

disc = selection[0..1]
track = selection[2..3]
chk_disc = disc.to_i-1
chk_track = track.to_i-1
unless collection[chk_disc].nil?
  unless collection[chk_disc][chk_track].nil?
    puts "Thank you!"
    `./upnext.sh #{disc} #{track}`
  else
    puts "Track not found."
  end
else
  puts "Track not found."
end
