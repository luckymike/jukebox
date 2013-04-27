#!/usr/local/bin/ruby

require "json"

last = Integer(ARGV[0])
collection = Array.new
count = 1
disc = count
while count <= last
  disc = count.to_s()
  if disc.size == 1
    disc = "0" + disc
  end
  tracks = `osascript -e 'tell application "iTunes"' -e ' get name of every track in playlist "#{disc}"' -e 'end tell'`
  collection << tracks.tr("\n","").split(", ")
  count += 1
end
puts collection

File.open('/tmp/collection.txt', 'w') {|f| f.write(collection.to_json) }

