class HashWia < Hash
  include HashWiaModule
end

class HashWia
  class NamedOptions
    def initialize hash
      @hash = hash
    end

    def set constant, code, name
      if code.class == Symbol
        code = code.to_s
      end

      @hash[constant.to_s] = code
      @hash[code]          = name.to_s
    end

    def method_missing code, key_val
      self.set code, key_val.keys.first, key_val.values.first
    end
  end
end

# to create Task::STATUS and Task.status
# HashWia self, :status do |opt|
#
# or just to get a hash
# HashWia do |opt|
#   opt.DONE d: 'Done'
#   # or
#   opt.set 'DONE', :d, 'Done'
# end
def HashWia klass = nil, name = nil, opts = nil
  if block_given?
    hash = HashWia.new

    if name
      if !opts || opts[:constant] != false
        constant = name.to_s.upcase
        klass.const_set constant, hash
      end

      klass.define_singleton_method(name) { klass.const_get(constant) }
    end

    named_opts = HashWia::NamedOptions.new hash
    yield named_opts
    hash
  else
    raise ArgumentError, 'Block not provided'
  end
end
