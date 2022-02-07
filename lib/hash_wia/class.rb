class HashWia < Hash
  include HashWiaModule
end

class HashWia
  class NamedOptions
    def initialize hash, &block
      @hash  = hash
      @block = block
    end

    def set constant, code, value
      @block.call constant.to_s, code, value
      @hash[constant.to_s] = code
      @hash[code]          = value
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
def HashWia klass = nil, opts = nil
  if block_given?
    hash = HashWia.new

    if klass.class == Hash
      opts = klass
      klass = nil
    end

    opts ||= {}

    named_opts = HashWia::NamedOptions.new hash do |constant, code, value|
      if opts[:constants]
        if klass
          klass.const_set "#{opts[:constants]}_#{constant}".upcase, code
        else
          raise "Host class not given (call as HashWia self, constants: ...)"
        end
      end
    end

    yield named_opts

    if opts[:method]
      klass.define_singleton_method(opts[:method]) { hash }
    end

    unless opts[:freeze] == false
      hash.freeze
    end

    hash
  else
    raise ArgumentError, 'Block not provided'
  end
end
