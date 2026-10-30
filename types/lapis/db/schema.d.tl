local db = require("lapis.db")

local enum ReferentialAction
  "cascade"
  "restrict"
  "set_null"
  "set_default"
  "no_action"
end

local record ColumnOptions
  null: boolean
  default: string | number | boolean | db.Raw
  unique: boolean
  primary_key: boolean
  array: boolean | number
  references: string | {string: string} | db.Raw
  on_delete: ReferentialAction
  on_update: ReferentialAction
  timezone: boolean
end

local record Types
  serial: function(ColumnOptions): string
  varchar: function(ColumnOptions): string
  text: function(ColumnOptions): string
  time: function(ColumnOptions): string
  date: function(ColumnOptions): string
  enum: function(ColumnOptions): string
  integer: function(ColumnOptions): string
  numeric: function(ColumnOptions): string
  real: function(ColumnOptions): string
  double: function(ColumnOptions): string
  boolean: function(ColumnOptions): string
  foreign_key: function(ColumnOptions): string
end

local type ColumnType = function(ColumnOptions): string
local type ColumnSpec = {string, ColumnType | string} | string

local record CreateTableOptions
  if_not_exists: boolean
end

local record IndexOptions
  unique: boolean
  concurrently: boolean
  if_not_exists: boolean
  method: string
  tablespace: string
  where: string
  index_name: string
end

local record DropIndexOptions
  cascade: boolean
  index_name: string
end

local record schema
  ColumnOptions: ColumnOptions
  types: Types
  create_table: function(string, {ColumnSpec}, ?CreateTableOptions)
  drop_table: function(string)
  create_index: function(string, ...: string | IndexOptions)
  drop_index: function(...: string | DropIndexOptions)
  add_column: function(string, string, ColumnType | string)
  drop_column: function(string, string)
  rename_column: function(string, string, string)
  rename_table: function(string, string)
  entity_exists: function(string): boolean
  gen_index_name: function(...: string | IndexOptions): string
end

return schema
