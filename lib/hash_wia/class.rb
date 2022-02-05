class HashWia < Hash
  include HashWiaModule
end

class HashWia
  class NamedOptions
    def initialize hash
      @hash = hash
    end

    def set code, constant, name = nil
      unless name
        name = constant.keys.first
        constant = constant.values.first
      end

      @hash[code.to_s]     = name.to_s
      @hash[constant.to_s] = code.to_s
    end

    def method_missing code, *args
      self.set code, *args
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
#   opt.DONE :d, 'Done'
# end
def HashWia klass = nil, name = nil
  if block_given?
    hash = HashWia.new

    if name
      constant = name.to_s.upcase
      klass.const_set constant, hash
      klass.define_singleton_method(name) { klass.const_get(constant) }
    end

    named_opts = HashWia::NamedOptions.new hash
    yield named_opts
    hash
  else
    raise ArgumentError, 'Block not provided'
  end
end
