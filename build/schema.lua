local db = require("lapis.db")
local lapis_schema = require("lapis.db.schema")
local types = lapis_schema.types

local TITLE_MAX = 255













local function create_todos()
   lapis_schema.create_table("todos", {
      { "id", types.serial({ primary_key = true }) },
      { "title", "character varying(" .. tostring(TITLE_MAX) .. ") NOT NULL" },
      { "done", types.boolean({ default = false }) },
      { "created_at", types.time({ default = db.raw("now()") }) },
   })
end

local value = {
   title_max = TITLE_MAX,
   create_todos = create_todos,
}

return value
