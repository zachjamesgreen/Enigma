require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it('should exist') { expect(enigma).to be_instance_of(Enigma) }

  it 'should #encrypt' do
    encrypted = enigma.encrypt("hello world", "02715", "040895")
    expect(encrypted).to eq({encryption: "keder ohulw", key: "02715", date: "040895"})
  end

  it 'should #decrypt' do
    encrypted = enigma.decrypt("keder ohulw", "02715", "040895")
    expect(encrypted).to eq({decryption: "hello world", key: "02715", date: "040895"})
  end

  it 'should #encrypt using todays date' do
    allow(Date).to receive(:today) {Date.new(2021,04,22)}
    encrypted = enigma.encrypt("hello world", "02715")
    expect(encrypted).to eq({encryption: "qgfaxbqd ny", key: "02715", date: Date.today.strftime('%d%m%y')})
  end

  it 'should #decrypt using todays date' do
    allow(Date).to receive(:today) {Date.new(2021,04,22)}
    encrypted = enigma.decrypt("qgfaxbqd ny", "02715")
    expect(encrypted).to eq({decryption: "hello world", key: "02715", date: Date.today.strftime('%d%m%y')})
  end

  it 'should #encrypt using todays date and a random key' do
    allow(Date).to receive(:today) {Date.new(2021,04,22)}
    allow(enigma).to receive(:generate_key) { '70361' }
    encrypted = enigma.encrypt("hello world")
    expect(encrypted).to eq({encryption: "djytkeiwnqq", key: '70361', date: Date.today.strftime('%d%m%y')})
  end
end