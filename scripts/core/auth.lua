-- prevent unauthorized acesss to the core lib
local helper = require ("cet_mod_manager/helper")
local paths = require ("cet_mod_manager/paths")

local auth = {}

local m_hash

local function writeHash()
  m_hash = helper.randomHash(12)
  local hash_path = (paths.cetmmRoot / "scripts" / "hash"):ToString()
  local file = io.open(hash_path, "w")
  file:write(m_hash)
  file:close()
end

function auth.Authenticate(op)
  if op == 0 then -- write hash
    writeHash()
  elseif op == m_hash then -- auth
    m_hash = nil
    return true
  else
    m_hash = nil
    error("unauthorized access to CETMM core.", 2)
  end
end

return auth