local model = require("lapis.db.model")
local schema = require("schema")

local record NewTodo
  title: string
  done: boolean
end

local record Todos
  record Todo is schema.Todo
    update: function(Todo, NewTodo)
    delete: function(Todo)
  end

  select: function(Todos, string): {Todo}
  create: function(Todos, NewTodo): Todo
  find: function(Todos, number): Todo | nil
end

local todos: Todos = model.Model:extend("todos")

return todos
