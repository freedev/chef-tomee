module Materialization
  def sym k ; k.respond_to?(:to_sym) ? k.to_sym : k end

  def materialize obj, parent=nil
    o = materialize_raw obj, parent
    return ::Mash.new(o) if o.is_a? Hash
    return o
  end

  def materialize_raw obj, parent=nil
    obj = obj.to_hash if obj.respond_to? :to_hash
    if obj.is_a? Hash
      obj = obj.inject({}) { |memo, (k,v)| memo[sym(k)] = v ; memo }
      obj.inject({}) { |memo, (k,v)| memo[sym(k)] = materialize_raw(v, obj) ; memo }
    elsif obj.is_a? Array
      obj.map { |o| materialize_raw(o, parent) }
    elsif obj.is_a? String
      obj % parent rescue obj
    else
      obj
    end
  end
end

class Chef
  class Recipe
    include Materialization
  end
end

class Chef
  class Resource
    include Materialization
  end
end