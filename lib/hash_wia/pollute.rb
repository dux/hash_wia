class Hash
  # { foo: :bar }.to_hwia            #
  # { foo: :bar }.to_hwia :foo, :bar # create struct and fill
  def to_hwia *args
    if args.first.nil?
      HashWia.new self
    else
      list = args.flatten
      name = 'DynStruct_' + list.join('_')
      HashWia::STRUCTS[name] ||= ::Struct.new(name, *list)
      HashWia::STRUCTS[name].new **self
    end
  end
end
