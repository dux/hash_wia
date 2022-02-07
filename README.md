# Hash WIA (with indifferent access)

Featrues a few useful Ruby Hash manipulations

* indifferent access - hash key as symbol or string
* strict key methods - raise error if accessing not defined key as a method
* easy struct creation

### Polluting a namespace

By default `HashWia` is polluting ruby `Hash` object with `to_hwia` method.

It provides easy access to `HashWia` `hash` and `struct` objects.

## Install

To install

`gem install hash_wia`

To use

```ruby
# Gefile
gem 'hash_wia'

# to user
require 'hash_wia'
```

## Infifferent + Mash for defined keys

You can convert any hash to Mash hash by using `to_hwia` method on a hash.

```ruby
h = HashWia.new {}
# or if polluted
h = {}.to_hwia
```

Examples

```ruby
mash = { foo: { bar: :baz }}.to_hwia
mash[:foo][:bar]   # :baz
mash['foo']['bar'] # :baz
mash.foo.bar       # :baz

mash.foo.bar = 123
mash[:foo].bar     #  123
mash[:foo].not_def #  ArgumentError

# As configuration
Lux.config.google = YAML.load('./config/google.yml').to_hwia
Lux.config.google.oauth.key  # ok
Lux.config.google.oauth.name # ArgumentError
```

Add new value to a key

```ruby
mash.foo.test   = 456
mash.foo[:test] = 456
mash.foo.test   # 456
```

Merge

```ruby
mash.merge! foo: { 'bar' => :baz }
mash.foo.bar     # baz
mash[:foo][:bar] # baz
```

It is basicly Rails Hash with indiferent access + key access on method calls.

#### Assigning a proc

You can assign a proc to a hash like this

```ruby
ch = {}.to_hwia

ch.proc_test1 = proc { |num| num * 123 }

# or more elegant
ch.proc_test2 do |num|
  num * 123
end

ch.test1.call(2) # 246
ch.test2.call(2) # 246
```

## Struct from hash

Uses arguments to creates unique Struct, caches base class.

Great for controller class instance variables and other options.

```ruby
h = {}.to_hwia :foo
h.foo       # nil
h.foo = 123 # ok
h.bar       # NoMethodError
h.foo       # 123
```

Examples

```ruby
# From array
opt = { foo: 1 }.to_hwia :foo, :bar
opt.bar = 2

# allows set on second level
opt.foo = { bar: :baz }
opt.foo[:bar] # :baz

# From Hash
opt = {foo: nil, bar: 2}.to_hwia [:foo, :bar, :baz]
opt.foo      # 1
opt.bar      # 2
opt.baz      # nil
opt.booz     # NoMethodError
```

## Freeze keys

You can freeze Hash keys and raise `NoMethodErorr` if new key is added.

```ruby
opt = {foo: nil, bar: 2}.to_hwia.freeze_keys!
opt.bar       # 2
opt.baz   = 3 # NoMethodErorr
opt[:baz] = 3 # NoMethodErorr
```

## Set named options

Easy way to set up option constants in your APP, in a proteced namespace without class polution, frozen.

Constant points to keyword and keyword points to a name.

```ruby
class Task
  # to create Task::STATUS and Task.status (default)
  STATUS = HashWia self, method: :status do |opt|
    opt.QUED    q: 'Qued'
    opt.RUNNING r: 'Running'
    opt.DONE    d: 'Done'
    opt.FAILED  e: 'Failed'
    opt.DEAD    x: 'Dead'
    # or use numbers
    opt.ACTIVE  1 => 'Task is active'
  end
end

# Enables following access
# Task::STATUS.FOO  # NoMethodError for not defined constants
#
# Task::STATUS.DONE # :d
#
# Task.status.DONE # :d
# Task.status.d    # 'Done'
# Task.status[:d]  # 'Done'
# Task.status['d'] # 'Done'
#
# Task.status.ACTIVE # 1
# Task.status[1]     # 'Task is active'
```

You can create a constant for every key as well

```ruby
class Foo
  STATUS = HashWia self, constants: :status, method: :status do |opt|
    opt.INACTIVE 0 => 'Inactive object'
    opt.ACTIVE   1 => 'Active object'
    opt.DEAD     2 => 'Dead object'
  end
end

# would generate
# Foo::STATUS[1]       # => 'Active object'
# Foo::STATUS.ACTIVE   # 1
# Foo::STATUS_INACTIVE # 0
# Foo::STATUS_ACTIVE   # 1
# Foo::STATUS_DEAD     # 2
```

## Dependencies

None.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dux/hash_hwia.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
