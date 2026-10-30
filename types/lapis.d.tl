local record Request
  params: {string: (string | nil)}
  todos: any
  csrf_token: string
  form_error: string | nil
  title_max: integer
end

local record Response
  status: integer
  render: string
  redirect_to: string
end

local record Application
  enable: function(Application, string)
  layout: any
  before_filter: function(Application, function(Request))
  get: function(Application, string, function(Request): Response)
  post: function(Application, string, function(Request): Response)
  metamethod __call: function(Application): Application
end

local record lapis
  Application: Application
  Request: Request
  Response: Response
end

return lapis
