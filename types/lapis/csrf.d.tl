local lapis = require("lapis")

local record csrf
  generate_token: function(lapis.Request): string
  validate_token: function(lapis.Request): boolean | nil, string
end

return csrf
