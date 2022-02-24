local path = require ("modules/core/class/path")
local _dofile = require ("modules/core/class/dofile")

---@class dofiles
---@field m_data dofile[]
local dofiles = {
  m_data = {},
}

-- public methods

function dofiles.Scan()
  dofiles.Clear()

  local dofile_list = dir("dofiles")
  for _, entry in ipairs(dofile_list) do
    if entry.type == "file" and entry.name:match("(.+)%.lua$") then
      local entry_path = path("dofiles") / entry.name
      table.insert(dofiles.m_data, _dofile(entry_path))
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