require_relative '../loader'

class Foo
  HashWia self, :bar do |opt|
    opt.BAZ b: 'Baz'
  end

  HashWia self, :baz, constant: false do |opt|
    opt.VAL b: 'Value'
  end

  OPTS = HashWia do |opt|
    opt.set 'OPTA', :a, 'A name'
    opt.OPTB b: 'B name'
    opt.ACTIVE 1 => 'Active foo'
  end
end

describe 'named options' do
  context 'defines class method' do
    it 'creates class constant' do
      expect(Foo::BAR.BAZ).to eq('b')
    end

    it 'creates class method to access constant' do
      expect(Foo.bar.BAZ).to eq('b')
    end

    it 'is accesible via native constant' do
      expect(Foo::OPTS[1]).to eq('Active foo')
    end

    it 'is accesible via native constant' do
      expect(Foo::OPTS.ACTIVE).to eq(1)
    end

    it 'if instructed does not create constant' do
      expect{ Foo::BAZ }.to raise_error NameError
    end
  end

  context 'does not pollute' do
    it 'creates via set' do
      expect(Foo::OPTS.OPTA).to eq('a')
    end

    it 'creates via method missing' do
      expect(Foo::OPTS.OPTB).to eq('b')
    end

    it 'gets name via code' do
      expect(Foo::OPTS[:b]).to eq('B name')
      expect(Foo::OPTS['b']).to eq('B name')
    end
  end
end
