require_relative '../loader'

describe 'struct from hash/array' do
  it 'can create struct from hash' do
    opt = { foo: 1, bar: 2 }.to_hwia :foo, :bar, :baz
    expect(opt.foo).to eq(1)
    expect(opt.bar).to eq(2)
    expect(opt.baz).to eq(nil)
    expect { opt.abc }.to raise_error NoMethodError
  end

  it 'expect to rasie argument error' do
    expect { opt = { foo: 1, bar: 2 }.to_hwia [:foo, :baz] }.to raise_error ArgumentError
  end

  it 'returns valid hash called 2x' do
    data = { foo: 1, bar: 2, baz: 3 }
    h1 = data.to_hwia
    h2 = h1.to_hwia :foo, :bar, :baz
    expect { h2.to_hwia :foo, :bar }.to raise_error ArgumentError
  end

  context 'with frozen keys' do
    it 'can be locked' do
      data = { foo: 1, bar: 1 }.to_hwia.freeze_keys!
      expect(data.foo).to eq(1)
      expect{ data[:baz] = 3 }.to raise_error FrozenError
      expect{ data.baz = 3 }.to raise_error FrozenError
    end

    it 'freezes keys after set' do
      data = {}.to_hwia :foo, :bar
      expect {data.baz = true}.to raise_error FrozenError
    end

    it 'can modify keys that allready exist' do
      data = { foo: 1, bar: 1 }.to_hwia.freeze_keys!
      expect{ data.bar = 2 }.not_to raise_error
      expect(data.bar).to eq(2)
    end
  end
end
