package = "hello"
version = "dev-1"

source = {
  url = ""
}

description = {
  summary = "Simple OpenResty application using Lapis",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1",
  "lapis >= 1.20.0",
  "lua-dotenv >= 1.1-1",
  "tableshape >= 2.8.0"
}

build = {
  type = "builtin",
  modules = {}
}
