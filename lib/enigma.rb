require 'date'
# Main class to encrypt/decrypt messages
class Enigma
  LEGEND = ('a'..'z').to_a << ' '

  def initialize; end

  def encrypt(message, key = nil, date = nil)
    key = generate_key if key == nil
    date = formatted_date if date == nil
    message_array = split_message(message)
    combined = []
    offsets = get_offsets(date)
    keys = get_keys(key)
    offsets.size.times do |i|
      combined << offsets[i] + keys[i]
    end
    encryption = []
    message_array.size.times do |i|
      if Enigma::LEGEND.index(message_array[i]) == nil
        encryption << message_array[i]
        next
      end
      encryption << Enigma::LEGEND[(Enigma::LEGEND.index(message_array[i])+combined[i % 4]) % 27]
    end
    {encryption: encryption.join, key: key, date: date}
  end

  def decrypt(ciphertext, key = nil, date = nil)
    key = generate_key if key == nil
    date = formatted_date if date == nil
    ciphertext_array = split_message(ciphertext)
    combined = []
    offsets = get_offsets(date)
    keys = get_keys(key)
    offsets.size.times do |i|
      combined << offsets[i] + keys[i]
    end
    decryption = []
    ciphertext_array.size.times do |i|
      if Enigma::LEGEND.index(ciphertext_array[i]) == nil
        decryption << ciphertext_array[i]
        next
      end
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
    # check date format to make sure it is correct
    key.split('').each_cons(2).map { |k| k.join.to_i }
  end

  def split_message(message)
    return message if message.class == Array

    message.split('').map { |m| m.downcase }
  end

  def crack_with_date(message, date)
    message_array = split_message(message)
    offsets = get_offsets(date)
    code = decrypt_end(message[-4..-1], offsets, message_array)
    decrypt = []
    message_array.size.times do |i|
      decrypt << decrypt_single_char(message_array[i], code[i % 4])
    end
    decrypt.join
  end

  def decrypt_single_char(enc_char, offset)
    index = Enigma::LEGEND.index(enc_char)
    Enigma::LEGEND[(index + (offset) * -1) % 27]
  end

  def decrypt_end(end_array, offsets, message_array)
    end_letters_array = [' ', 'e', 'n', 'd']
    start_point = message_array.size % 4
    array = []
    a = {}
    4.times do |i|
      distance = (Enigma::LEGEND.index(end_array[i]) - Enigma::LEGEND.index(end_letters_array[i]))
      s = (start_point+i)%4
      array << (distance % 27) - offsets[s]
      a[(start_point+i)%4] = distance
    end
    a
  end
end