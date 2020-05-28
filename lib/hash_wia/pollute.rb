class Hash
  # { foo: :bar }.to_hwia            #
  # { foo: :bar }.to_hwia :foo, :bar # create struct and fill
  def to_hwia *args
    unless args.first
      HashWia.new self
    else
      list = args.flatten
      name = 'DynStruct_' + list.join('_')
      HashWia::STRUCTS[name] ||= ::Struct.new(name, *list)

      HashWia::STRUCTS[name].new.tap do |o|
        each do |k, v|
          o.send('%s=' % k, v) unless v.nil?
        end
      end
    end
  end
end
