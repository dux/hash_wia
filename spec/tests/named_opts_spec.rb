require_relative '../loader'

class Foo
  BAR = HashWia self, method: :bar do |opt|
    opt.BAZ b: 'Baz'
  end

  HashWia self, method: :baz do |opt|
    opt.VAL b: 'Value'
  end

  OPTS = HashWia do |opt|
    opt.set 'OPTA', :a, 'A name'
    opt.OPTB b: 'B name'
    opt.ACTIVE 1 => 'Active foo'
  end

  UNFOROZEN = HashWia freeze: false do |opt|
    opt.ONE 1 => 'one'
  end

  # creates
  # STATUS_INACTIVE # => 0
  # ...
  STATUS = HashWia self, constants: :status do |opt|
    opt.INACTIVE 0 => 'Inactive object'
    opt.ACTIVE   1 => 'Active object'
    opt.DEAD     2 => 'Dead object'
  end
end

describe 'named options' do
  context 'defines class method' do
    it 'creates class constant' do
      expect(Foo::BAR.BAZ).to eq(:b)
    end

    it 'creates class method to access constant' do
      expect(Foo.bar.BAZ).to eq(:b)
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
      expect(Foo::OPTS.OPTA).to eq(:a)
    end

    it 'creates via method missing' do
      expect(Foo::OPTS.OPTB).to eq(:b)
    end

    it 'gets name via code' do
      expect(Foo::OPTS[:b]).to eq('B name')
      expect(Foo::OPTS['b']).to eq('B name')
    end

    it 'ensures hash is frozen' do
      expect{Foo::OPTS.ACTIVE = 2}.to raise_error FrozenError
    end

    it 'does not freeze if freeze false option given' do
      expect{Foo::UNFOROZEN.ONE = 2}.not_to raise_error
    end

    it 'creates constants' do
      expect(Foo::STATUS[1]).to eq('Active object')
      expect(Foo::STATUS.ACTIVE).to eq(1)
      expect(Foo::STATUS_INACTIVE).to eq(0)
      expect(Foo::STATUS_ACTIVE).to eq(1)
      expect(Foo::STATUS_DEAD).to eq(2)
    end
  end
end
