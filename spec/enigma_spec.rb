require './lib/enigma'

RSpec.describe Enigma do
  it 'should exist' do
    enigma = Enigma.new
    expect(enigma).to be_instance_of(Enigma)
  end
end