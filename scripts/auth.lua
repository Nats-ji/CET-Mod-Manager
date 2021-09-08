local auth = {}

function auth.GetCore()
  json.CETMM_core(0)
  local file = io.open("scripts/hash", "r")
  if file then
    local hash = file:read()
    file:close()
    os.remove("scripts/hash")
    return json.CETMM_core(hash)
  else
    error("can't access to CETMM core.", 2)
  end
end

return auth