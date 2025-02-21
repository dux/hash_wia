desc 'Console with loaded gem'
task :console do
  require 'pry'
  require './lib/hash_wia'

  pry
end

desc 'Rerun code on change'
task :dev do
  system "find lib spec | entr -r bundle exec rspec"
end

task :speed do
  require 'benchmark'
  require './lib/hash_wia'

  data = {foo: 123, bar: 456}
  n = 100_000
  opt = Struct.new 'SomeOpts', :foo, :bar, :baz

  Benchmark.bm do |x|
    @hwia_time   = x.report('hwia  :') { n.times { o = data.to_hwia(:foo, :bar, :baz); o.foo + o.bar } }
    @struct_time = x.report('struct:') { n.times { o = opt.new(**data); o.foo + o.bar } }
    @hash_time   = x.report('hash  :') { n.times { data[:foo] + data[:bar] } }
  end

  def report name, kind
    multiplier = @hwia_time.real / kind.real
    percent_diff = ((multiplier - 1) * 100).round(2)
    puts "#{name} is #{multiplier.round(2)}x faster"
  end

  puts
  report 'Struct', @struct_time
  report 'Plain Hash', @hash_time
end
