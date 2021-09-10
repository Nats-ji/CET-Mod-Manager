local path = require ("scripts/core/class/path")
local _dofile = require ("scripts/core/class/dofile")

local dofiles = {
  data = {},
}

-- public methods

function dofiles.Scan()
  dofiles.Clear()

  local dofile_list = dir("dofiles")
  for _, entry in ipairs(dofile_list) do
    if entry.type == "file" and entry.name:match("(.+)%.lua$") then
      local entry_path = path("dofiles") / entry.name
      table.insert(dofiles.data, _dofile(entry_path))
    end
  end

end

function dofiles.Clear()
  dofiles.data = {}
end

function dofiles.Get()
  return dofiles.data
end

return dofiles