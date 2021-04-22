require 'date'
# Main class to encrypt/decrypt messages
class Enigma
  LEGEND = ('a'..'z').to_a << ' '

  def initialize; end

  def encrypt(message, key = nil, date = nil)
    key = generate_key if key == nil
    date = formatted_date if date == nil
    message_array = message.split('')
    combined = []
    offsets = (date.to_i ** 2).to_s.split('')[-4..-1].map { |d| d.to_i }
    keys = key.split('').each_cons(2).map { |g| g.join.to_i }
    offsets.size.times do |i|
      combined << offsets[i] + keys[i]
    end
    encryption = []
    message_array.size.times do |i|
      encryption << Enigma::LEGEND[(Enigma::LEGEND.index(message_array[i])+combined[i % 4]) % 27]
    end
    {encryption: encryption.join, key: key, date: date}
  end

  def decrypt(ciphertext, key, date = Date.today); end

  def generate_key
    rand = Random.rand 100000
    digits = rand.digits
    until digits.size == 5 do
      digits.unshift 0
    end
    digits.join('')
  end

  def formatted_date
    Date.today.strftime '%d%m%y'
  end
end
