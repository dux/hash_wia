class Hash
  # { foo: :bar }.to_hwia            #
  # { foo: :bar }.to_hwia :foo, :bar # create struct and fill
  def to_hwia *args
    if args.first.nil?
      self.extend HashWiaModule
    else
      list  = args.map(&:to_s).flatten
      extra = keys.map(&:to_s) - list

      if extra.first
        raise ArgumentError.new('Unallowed key/s: %s' % extra.map{ |_| ':%s' % _ }.join(', '))
      end

      HashWia.new.tap do |o|
        list.each do |k|
          o[k] = self[k]
          o[k] = self[k.to_sym] if o[k].nil?
        end
      end
    end
  end
end
