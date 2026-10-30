local record Shape<T>
  transform: function(Shape<T>, any): T | nil, string | nil
end

local record types
  db_id: Shape<number>
  empty: Shape<nil>
  limited_text: function(integer, ?integer): Shape<string>
end

return types
