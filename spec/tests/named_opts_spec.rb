require_relative '../loader'

class Foo
  HashWia self, :bar do |opt|
    opt.BAZ b: 'Baz'
  end

  OPTS = HashWia do |opt|
    opt.set :a, 'OPTA', 'A name'
    opt.OPTB :b, 'B name'
    opt.c OPTC: 'C name'
    opt.OPTD d: 'D name'
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
  end

  context 'does not pollute' do
    it 'creates via set' do
      expect(Foo::OPTS.OPTA).to eq('a')
    end

    it 'creates via method missing' do
      expect(Foo::OPTS.OPTB).to eq('B name')
    end

    it 'creates via method missing alt' do
      expect(Foo::OPTS[:c]).to eq('OPTC')
    end

    it 'creates via hash access' do
      expect(Foo::OPTS.OPTD).to eq('d')
    end
  end
end
