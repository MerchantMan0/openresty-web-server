local lapis = require("lapis")
local csrf = require("lapis.csrf")
local types = require("lapis.validate.types")
local schema = require("schema")
local Todos = require("models.todos")

local app = lapis.Application()
app:enable("etlua")
app.layout = false

local title_type = types.limited_text(schema.title_max)

local function reject_csrf(self)
   if not csrf.validate_token(self) then
      return { status = 403 }
   end
   return nil
end

local function validation_error(self)
   self.todos = Todos:select("order by id")
   self.form_error = "Title must be at most " .. tostring(schema.title_max) .. " characters"
   return { status = 400, render = "index" }
end

local function todo_id(value)
   local id, err = types.db_id:transform(value)
   if err ~= nil or id == nil or id < 1 then
      return nil
   end
   return id
end

local function blank_title(value)
   local _, err = types.empty:transform(value)
   return err == nil
end

app:before_filter(function(self)
   self.csrf_token = csrf.generate_token(self)
   self.title_max = schema.title_max
end)

app:get("/", function(self)
   self.todos = Todos:select("order by id")
   return { render = "index" }
end)

app:post("/todos", function(self)
   local rejected = reject_csrf(self)
   if not (rejected == nil) then
      return rejected
   end
   if blank_title(self.params.title) then
      return { redirect_to = "/" }
   end
   local title, err = title_type:transform(self.params.title)
   if title == nil or err ~= nil then
      return validation_error(self)
   end
   Todos:create({
      title = title,
      done = false,
   })
   return { redirect_to = "/" }
end)

app:post("/todos/:id", function(self)
   local rejected = reject_csrf(self)
   if not (rejected == nil) then
      return rejected
   end
   local id = todo_id(self.params.id)
   if id == nil then
      return { status = 404 }
   end
   local todo = Todos:find(id)
   if todo == nil then
      return { status = 404 }
   end
   local title = todo.title
   if not blank_title(self.params.title) then
      local parsed, err = title_type:transform(self.params.title)
      if parsed == nil or err ~= nil then
         return validation_error(self)
      end
      title = parsed
   end
   todo:update({
      title = title,
      done = self.params.done == "1",
   })
   return { redirect_to = "/" }
end)

app:post("/todos/:id/delete", function(self)
   local rejected = reject_csrf(self)
   if not (rejected == nil) then
      return rejected
   end
   local id = todo_id(self.params.id)
   if id == nil then
      return { status = 404 }
   end
   local todo = Todos:find(id)
   if todo == nil then
      return { status = 404 }
   end
   todo:delete()
   return { redirect_to = "/" }
end)

return app
