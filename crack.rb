require 'pry'
require 'awesome_print'
require './lib/enigma'

e = Enigma.new

message_file_path = ARGV[0]
cracked_file_path = ARGV[1]
date = ARGV[2]


message_file = File.open(message_file_path, 'rt')
if date
  cracked = e.crack(message_file.read, date)
else
  cracked = e.crack(message_file.read)
end
File.new(cracked_file_path, 'w').write(cracked)

puts "Created '#{cracked_file_path}'"