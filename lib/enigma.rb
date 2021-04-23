require 'date'
# Main class to encrypt/decrypt messages
class Enigma
  LEGEND = ('a'..'z').to_a << ' '

  def initialize; end

  def encrypt(message, key = nil, date = nil)
    key = generate_key if key == nil
    date = formatted_date if date == nil
    message_array = message.split('').map { |m| m.downcase }
    combined = []
    offsets = get_offsets(date)
    keys = get_keys(key)
    offsets.size.times do |i|
      combined << offsets[i] + keys[i]
    end
    encryption = []
    message_array.size.times do |i|
      encryption << Enigma::LEGEND[(Enigma::LEGEND.index(message_array[i])+combined[i % 4]) % 27]
    end
    {encryption: encryption.join, key: key, date: date}
  end

  def decrypt(ciphertext, key = nil, date = nil)
    key = generate_key if key == nil
    date = formatted_date if date == nil
    ciphertext_array = ciphertext.split('').map { |m| m.downcase }
    combined = []
    offsets = get_offsets(date)
    keys = get_keys(key)
    offsets.size.times do |i|
      combined << offsets[i] + keys[i]
    end
    decryption = []
    ciphertext_array.size.times do |i|
      decryption << Enigma::LEGEND[(Enigma::LEGEND.index(ciphertext_array[i])-combined[i % 4]) % 27]
    end
    {decryption: decryption.join, key: key, date: date}
  end

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

  def get_offsets(date)
    (date.to_i ** 2).to_s.split('')[-4..-1].map { |d| d.to_i }
  end

  def get_keys(key)
    key.split('').each_cons(2).map { |k| k.join.to_i }
  end
end
