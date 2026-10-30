local record Model
  extend: function<T>(Model, string): T
end

local record model
  Model: Model
end

return model
