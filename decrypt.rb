require 'pry'
require 'awesome_print'
require './lib/enigma'

e = Enigma.new

encrypted_file_path = ARGV[0]
decrypted_file_path = ARGV[1]
key = ARGV[2]
date = ARGV[3]

message_file = File.open(encrypted_file_path, 'rt')
decrypt = e.decrypt(message_file.read, key, date)

File.new(decrypted_file_path, 'w').write(decrypt[:decryption])

puts "Created '#{decrypted_file_path}' with the key #{decrypt[:key]} and date #{decrypt[:date]}"
