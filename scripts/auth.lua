local auth = {}

function auth.GetCore()
  if pcall(json.CETMM_core, 0) then
    local file = io.open("scripts/hash", "r")
    if file then
      local hash = file:read()
      file:close()
      os.remove("scripts/hash")
      return json.CETMM_core(hash)
    end
  end
  error("can't access CETMM core library. Check if cet_mod_manager.asi loaded.", 1)
end

return auth