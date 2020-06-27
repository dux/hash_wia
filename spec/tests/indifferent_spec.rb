require_relative '../loader'

describe 'clean hash' do
  context 'default mode' do
    let(:h_default) do
      {
        a1: {
          'a2' => {
            a3: :a3_foo,
            b3: true
          }
        },
        b1: {
          'b2' => :b2_foo
        }
      }.to_hwia
    end

    it 'works like hashie mash' do
      expect(h_default.a1.a2.a3).to eq(:a3_foo)
      expect(h_default[:a1]['a2'].a3).to eq(:a3_foo)
    end

    it 'raises error when accessing as method for key not found' do
      expect { h_default.a1.not_found_}.to raise_error ArgumentError
    end

    it 'returns list keys and values' do
      expect(h_default.a1.a2.keys).to eq([:a3, :b3])
      expect(h_default.a1.a2.values).to eq([:a3_foo, true])
    end

    it 'can set deep value' do
      base = h_default
      base.a1.a2.a3 = :foo
      expect(base.a1.a2.a3).to eq(:foo)
    end

    it 'can set all type of keys' do
      h = {}.to_hwia
      h[:foo1]  = :foo1
      h['foo2'] = :foo2
      h.foo3    = :foo3

      expect(h[:foo1]).to eq(:foo1)
      expect(h[:foo2]).to eq(:foo2)
      expect(h[:foo3]).to eq(:foo3)
    end

    it 'uses string key as a default' do
      h = {}.to_hwia
      h[:foo]  = { :bar => :symbol, 'bar' => 'string' }
      expect(h.foo.bar).to eq('string')
      expect(h[:foo]['bar']).to eq('string')
    end

    it 'allows weird key' do
      name  = 'a?#b'
      value = :value

      h = {}.to_hwia
      h[name] = value

      expect(h[name]).to eq(value)
    end

    it 'it allows special key name' do
      h = { foo: :bar, keys: :baz }.to_hwia

      expect(h.keys).to eq([:foo, :keys])
      expect(h[:keys]).to eq(:baz)
      expect(h['keys']).to eq(:baz)
    end

    it 'can add proc to hash' do
      h = {}.to_hwia
      h.proc_test do |num|
        num * 123
      end

      expect(h.proc_test.call(2)).to eq(246)
    end

    it 'responds to each' do
      data = []

      for k, v in h_default
        data.push k
      end

      expect(data).to eq([:a1, :b1])
    end

    it 'deletes a key' do
      h = h_default
      expect(h[:a1][:a2].delete(:a3)).to eq(:a3_foo)
      expect(h[:a1][:a2].delete(:a3)).to eq(nil)
    end

    it 'can delete keys' do
      h = { :foo => :bar, bar: :baz }.to_hwia
      expect(h[:foo]).to eq(:bar)
      h.delete(:foo)
      expect(h[:foo]).to eq(nil)

      expect(h[:bar]).to eq(:baz)
      h.delete('bar')
      expect(h[:bar]).to eq(nil)
      expect(h['bar']).to eq(nil)
    end

    it 'can access complex keys' do
      h = { 123 => :foo, String => :bar }.to_hwia

      expect(h[123]).to eq(:foo)
      expect(h[String]).to eq(:bar)
    end

    it 'can add keys' do
      h = { :foo => :bar, String => :bar }.to_hwia
      h[:bar] = {}
      h[:bar][:baz] = 123

      expect(h.bar.baz).to eq 123
      expect(h[:bar].baz).to eq 123
      expect(h.bar[:baz]).to eq 123
    end

    it 'can merge' do
      h  = { foo: :bar }.to_hwia
      nh = h.merge(foo: { jaz: :baz})
      expect(h.foo).to eq(:bar)
      expect(nh.foo.jaz).to eq(:baz)

      h.merge!(foo: { jaz: :baz})
      expect(h.foo.jaz).to eq(:baz)
    end
  end
end