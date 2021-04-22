require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it('should exist') { expect(enigma).to be_instance_of(Enigma) }

  it 'should #encrypt' do
    encrypted = enigma.encrypt("hello world", "02715", "040895")
    expect(encrypted).to eq({encryption: "keder ohulw", key: "02715", date: "040895"})
  end

  it 'should #decrypt' do
    encrypted = enigma.decrypt("hello world", "02715", "040895")
    expect(encrypted).to eq({encryption: "keder ohulw", key: "02715", date: "040895"})
  end

  xit 'should #encrypt using todays date' do
    encrypted = enigma.encrypt("hello world", "02715")

    expect(encrypted).to eq({encryption: "keder ohulw", key: "02715", date: Date.today.strftime '%d%m%y'})
  end

  xit 'should #decrypt using todays date' do
    encrypted = enigma.decrypt("hello world", "02715")
    expect(encrypted).to eq({encryption: "keder ohulw", key: "02715", date: Date.today.strftime '%d%m%y'})
  end

  xit 'should #encrypt using todays date and a random key' do
    allow(enigma).to receive(generate_key) { '70361' }
    encrypted = enigma.encrypt("hello world")
    expect(encrypted).to eq({encryption: "keder ohulw", key: '70361', date: Date.today.strftime '%d%m%y'})
  end
end