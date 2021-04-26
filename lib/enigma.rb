require 'date'
# Main class to encrypt/decrypt messages
class Enigma
  LEGEND = ('a'..'z').to_a << ' '

  def initialize; end

  def encrypt(message, key = nil, date = nil)
    key = generate_key if key.nil?
    date = formatted_date if date.nil?
    transform(split_message(message), combine(date, key))
    {encryption: encryption.join, key: key, date: date}
  end

  def decrypt(ciphertext, key = nil, date = nil)
    key = generate_key if key.nil?
    date = formatted_date if date.nil?
    decryption = transform(split_message(ciphertext), combine(date, key))
    {decryption: decryption.join, key: key, date: date}
  end

  def combine(date, key)
    offsets = get_offsets(date)
    keys = get_keys(key)
    (0..3).collect do |i|
      offsets[i] + keys[i]
    end
  end

  def transform(text_array, distance_array)
    (0..(text_array.size - 1)).collect do |i|
      if Enigma::LEGEND.index(text_array[i]).nil?
        text_array[i]
        next
      end
      Enigma::LEGEND[(Enigma::LEGEND.index(text_array[i]) - distance_array[i % 4]) % 27]
    end
  end

  def generate_key
    rand = Random.rand 100_000
    digits = rand.digits
    digits.unshift 0 until digits.size == 5
    digits.join('')
  end

  def formatted_date
    Date.today.strftime '%d%m%y'
  end

  def get_offsets(date)
    (date.to_i**2).to_s.split('')[-4..-1].map(&:to_i)
  end

  def get_keys(key)
    # check date format to make sure it is correct
    key.split('').each_cons(2).map { |k| k.join.to_i }
  end

  def split_message(message)
    return message if message.instance_of?(Array)

    message.split('').map(&:downcase)
  end

  def crack(message, date = formatted_date)
    message_array = split_message(message)
    code = decrypt_end(message[-4..-1], message_array)
    decrypt = []
    message_array.size.times do |i|
      decrypt << decrypt_single_char(message_array[i], code[i % 4])
    end
    decrypt.join
  end

  def decrypt_single_char(enc_char, offset)
    index = Enigma::LEGEND.index(enc_char)
    return enc_char if index.nil?

    Enigma::LEGEND[(index + (offset * -1)) % 27]
  end

  def decrypt_end(end_array, message_array)
    end_letters_array = [' ', 'e', 'n', 'd']
    start_point = message_array.size % 4
    a = {}
    4.times do |i|
      distance = (Enigma::LEGEND.index(end_array[i]) - Enigma::LEGEND.index(end_letters_array[i]))
      a[(start_point + i) % 4] = distance
    end
    a
  end
end