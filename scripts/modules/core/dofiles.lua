local paths = require ("cet_mod_manager/paths")
local filesystem = require ("cet_mod_manager/filesystem")
local _dofile = require ("cet_mod_manager/class/dofile")

---@class dofiles
---@field m_data dofile[]
local dofiles = {
  m_data = {},
}

-- public methods

function dofiles.Scan()
  dofiles.Clear()

  local scan_dir = paths.cetmmAsiRoot / "dofiles"
  local dofile_list = filesystem.List(scan_dir, true)
  for _, entry in ipairs(dofile_list) do
    print("dofile:", entry:ToString())
    if entry:Extension():ToString() == ".lua" then
      table.insert(dofiles.m_data, _dofile(entry))
    end
  end

end

function dofiles.Clear()
  dofiles.m_data = {}
end

function dofiles.Get()
  return dofiles.m_data
end

return dofiles