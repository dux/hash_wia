desc 'Console with loaded gem'
task :console do
  require 'pry'
  require './lib/hash_wia'

  pry
end

task :speed do
  require 'benchmark'
  require './lib/hash_wia'

  data = {foo: 123, bar: 456}
  n = 100_000
  opt = Struct.new 'SomeOpts', :foo, :bar, :baz
  Benchmark.bm do |x|
    x.report { n.times { foo = data.to_hwia(:foo, :bar, :baz) } }
    x.report { n.times { foo = opt.new(**data) } }
  end
end
