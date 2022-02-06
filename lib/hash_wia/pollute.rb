class Hash
  # { foo: :bar }.to_hwia            #
  # { foo: :bar }.to_hwia :foo, :bar # create struct and fill
  def to_hwia *args
    unless args.first
      HashWia.new self
    else
      list  = args.flatten
      extra = keys - list

      if extra.first
        raise ArgumentError.new('Unallowed key/s: %s' % extra.map{ |_| ':%s' % _ }.join(', '))
      end

      HashWia.new.tap do |o|
        list.each do |k|
          o[k] = self[k]
        end

        o.freeze_keys!
      end
    end
  end
end
