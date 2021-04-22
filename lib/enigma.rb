# Main class to encrypt/decrypt messages
class Enigma
  LEGEND = ('a'..'z').to_a << ' '

  def initialize; end

  def encrypt(message, key = generate_key, date = formated_date)
    message_array = message.split('')



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

  def formated_date
    Date.today.strftime '%d%m%y'
  end
end
