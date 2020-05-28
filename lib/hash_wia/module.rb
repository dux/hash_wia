module HashWiaModule
  def initialize hash=nil
    if hash
      hash.each { |k,v| self[k] = v }
    end
  end

  def [] key
    data = super key
    data = super key.to_s if data.nil?
    data = super key.to_sym if key.respond_to?(:to_sym) && data.nil?

    # if we are returning hash as a value, just include with wia methods hash
    data.extend HashWiaModule if data.is_a?(Hash)

    data
  end

  def []= key, value
    delete key
    delete key.to_s
    delete key.to_sym if key.respond_to?(:to_sym)

    super key, value
  end

  # we never return array from hash, ruby internals
  def to_ary
    nil
  end

  # key is common id direct access
  # allow direct get or fuction the same if name given
  def key name=nil
    name ? self[name] : self[:key]
  end

  # true clone of the hash with 0 references to the old one
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def method_missing name, *args, &block
    strname = name.to_s

    if strname.sub!(/\?$/, '')
      # h.foo?
      !!self[strname]
    elsif strname.sub!(/=$/, '')
      # h.foo = :bar
      self[strname.to_sym] = args.first
    else
      value = self[strname]

      if value.nil?
        if block
          # h.foo { rand }
          self[name] = block
        else
          # h.foo
          raise ArgumentError.new('%s not defined' % strname)
        end
      else
        value
      end
    end
  end
end
