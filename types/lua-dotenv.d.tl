local record dotenv
  load: function(?string): boolean, string
  get: function(string, ?string): string | nil
end

return dotenv
