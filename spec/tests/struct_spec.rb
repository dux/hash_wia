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
end
