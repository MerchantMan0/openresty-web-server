local config = require("lapis.config")
local dotenv = require("lua-dotenv")

local loaded, load_err = dotenv.load(".env")
if not loaded then
  error(load_err)
end

local MIN_SECRET_LENGTH = 32

local function env(key: string): string
  local value = dotenv.get(key)
  if value == nil or value == "" then
    error("missing environment variable " .. key)
  end
  return value
end

local function session_secret(): string
  local value = env("SECRET")
  if #value < MIN_SECRET_LENGTH then
    error("SECRET must be at least " .. tostring(MIN_SECRET_LENGTH) .. " characters")
  end
  return value
end

local port = tonumber(env("POSTGRES_PORT"))
if port == nil then
  error("POSTGRES_PORT must be a number")
end

local secret = session_secret()

local postgres = {
  host = env("POSTGRES_HOST"),
  port = port,
  user = env("POSTGRES_USER"),
  password = env("POSTGRES_PASSWORD"),
  database = env("POSTGRES_DATABASE"),
}

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",
  port = 8080,
  secret = secret,
  hmac_digest = "sha256",
  postgres = postgres,
})

config("production", {
  server = "nginx",
  code_cache = "on",
  num_workers = "4",
  port = 8080,
  secret = secret,
  hmac_digest = "sha256",
  postgres = postgres,
})
