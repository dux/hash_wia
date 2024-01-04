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
    data = super(key)
    skey = key.to_s
    data = super(skey) if data.nil?
    data = super(skey.to_sym) if data.nil? && key.class != Symbol

    if data.is_a?(Hash)
      data.extend HashWiaModule
      data
    else
      data
    end
  end

  def []= key, value
    key = key.to_s unless key.class == Symbol
    super key, value
  end

  def delete key
    data = super(key)
    skey = key.to_s
    data = super(skey) if data.nil?
    data = super(skey.to_sym) if data.nil? && key.class != Symbol
    data
  end

  # we never return array from hash, ruby internals
  def to_ary
    nil
  end

  # key is common id direct access
  # allow direct get or fuction the same if name given
  def key name = nil
    self[name.nil? ? :key : name]
  end

  # true clone of the hash with 0 references to the old one
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def merge hash
    dup.tap do |h|
      hash.each { |k, v| h[k.to_s] = v }
    end
  end

  def merge! hash
    hash.each { |k, v| self[k.to_s] = v }
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

  def dig *args
    root = self
    while args[0]
      key = args.shift
      root = root[key] || root[key.to_s]
      return if root.nil?
      root = HashWia.new root if root.class == Hash
    end
    root
  end

  def method_missing name, *args, &block
    strname = name.to_s

    if strname.sub!(/\?$/, '')
      # h.foo?
      !!self[strname]
    elsif strname.sub!(/=$/, '')
      # h.foo = :bar
      self[strname] = args.first
    else
      value = self[strname]
      value = self[strname.to_sym] if value.nil?

      if value.nil?
        if block
          self[strname.to_s] = block
        else
          if key?(strname) || key(strname.to_sym)
            nil
          else
            raise NoMethodError.new('%s not defined in HashWia' % strname)
          end
        end
      else
        value
      end
    end
  end
end
