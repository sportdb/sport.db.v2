

# module JsonSerializable
#  def to_json(*args)
#    as_json.to_json(*args)
#  end
# end

###
##  add as_json  to Object/Array/Hash
class Object
  def as_json(*)
    self
  end
end

class Array
  def as_json(*)
    map { |v| v.as_json }
  end
end

class Hash
  def as_json(*)
    each_with_object({}) do |(k, v), h|
      h[k.to_s] = v.as_json
    end
  end
end
