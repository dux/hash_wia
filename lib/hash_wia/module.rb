module HashWiaModule
  def initialize hash=nil
    if hash
      hash.each { |k,v| self[k] = v }
    end
  end

  # overload common key names with
  %i(size length zip minmax store cycle chunk sum uniq chain).each do |el|
    define_method el do
      self[el]
    end
  end

  def [] key
    data = super key
    data = super key.to_s if data.nil?
    data = super key.to_sym if key.respond_to?(:to_sym) && data.nil?

    # if we are returning hash as a value, just include with wia methods hash
    if data.is_a?(Hash)
      data.extend HashWiaModule
    end

    data
  end

  def []= key, value
    if @frozen_keys
      raise NoMethodError, "Hash keys are frozen and can't be modified"
    end

    delete key
    super key, value
  end

  def delete key
    self[key].tap do
      super key
      super key.to_s
      super key.to_sym if key.respond_to?(:to_sym)
    end
  end

  # we never return array from hash, ruby internals
  def to_ary
    nil
  end

  # key is common id direct access
  # allow direct get or fuction the same if name given
  def key name=nil
    name.nil? ? self[:key] : self[name.to_s]
  end

  # true clone of the hash with 0 references to the old one
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def merge hash
    dup.tap do |h|
      hash.each { |k, v| h[k] = v }
    end
  end

  def freeze_keys!
    @frozen_keys = true
    self
  end

  def each &block
    to_a.each do |key, data|
      if data.is_a?(Hash)
        data.extend HashWiaModule
      end

      block.call key, data
    end

    self
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
        elsif !keys.include?(name.to_sym)
          # h.foo
          raise NoMethodError.new('%s not defined' % strname)
        else
          nil
        end
      else
        value
      end
    end
  end
end
