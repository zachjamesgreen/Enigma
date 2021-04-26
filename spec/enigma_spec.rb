require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it('should exist') { expect(enigma).to be_instance_of(Enigma) }

  it 'should #encrypt' do
    encrypted = enigma.encrypt('hello world', '02715', '040895')
    expect(encrypted).to eq({ encryption: 'keder ohulw', key: '02715', date: '040895' })
  end

  it 'should #decrypt' do
    encrypted = enigma.decrypt('keder ohulw', '02715', '040895')
    expect(encrypted).to eq({ decryption: 'hello world', key: '02715', date: '040895' })
  end

  it 'should #encrypt using todays date' do
    encrypted = enigma.encrypt('hello world', '02715')
    expect(encrypted).to eq({ encryption: 'qgfaxbqd ny', key: '02715', date: Date.today.strftime('%d%m%y') })
  end

  it 'should #decrypt using todays date' do
    allow(Date).to receive(:today) { Date.new(2021, 04, 22) }
    encrypted = enigma.decrypt('qgfaxbqd ny', '02715')
    expect(encrypted).to eq({ decryption: 'hello world', key: '02715', date: Date.today.strftime('%d%m%y') })
  end

  it 'should #encrypt using todays date and a random key' do
    allow(Date).to receive(:today) { Date.new(2021, 0o4, 22) }
    allow(enigma).to receive(:generate_key) { '70361' }
    encrypted = enigma.encrypt('hello world')
    expect(encrypted).to eq({ encryption: 'djytkeiwnqq', key: '70361', date: Date.today.strftime('%d%m%y') })
  end

  it 'should #crack' do
    allow(Date).to receive(:today) { Date.new(2021, 04, 23) }
    allow(enigma).to receive(:generate_key) { '70361' }
    encrypted = enigma.encrypt('zachary end')
    expect(encrypted[:encryption]).to eq('vfppxwkhasq')
    crack = enigma.crack(encrypted[:encryption])
    expect(crack).to eq('zachary end')
  end

  it 'should encrypt/decrypt the alphabet' do
    encrypted = enigma.encrypt('the five boxing wizards jump quickly.', '59421', '160891')
    expect(encrypted).to eq({ encryption: 'abavncr hwksqhcvdcvwzyovroikhkqdkeht.', key: '59421',
                              date: '160891' })
    decrypted = enigma.decrypt(encrypted[:encryption], encrypted[:key], encrypted[:date])
    expect(decrypted).to eq({ decryption: 'the five boxing wizards jump quickly.', key: '59421',
                              date: '160891' })
  end

  it 'should generate random key and have padded zeros' do
    10_000.times do |_i|
      encrypted = enigma.encrypt('the five boxing wizards jump quickly.')
      key = encrypted[:key]
      expect(key.size).to eq(5) if key.include?('0') && key[0] == '0'
    end
  end
end
