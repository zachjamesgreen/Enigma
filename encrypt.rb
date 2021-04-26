require 'pry'
require 'awesome_print'
require './lib/enigma'

e = Enigma.new

message_file_path = ARGV[0]
encrypted_file_path = ARGV[1]


message_file = File.open(message_file_path, 'rt')
encrypt = e.encrypt(message_file.read)
File.new(encrypted_file_path, 'w').write(encrypt[:encryption])

puts "Created '#{encrypted_file_path}' with the key #{encrypt[:key]} and date #{encrypt[:date]}"