local helper = require ("cet_mod_manager/helper")

---@class dofile
---@field m_name string
---@field m_path path
---@field m_formated_name string
local _dofile = {}
_dofile.__index = _dofile

-- dofile constructor

setmetatable(_dofile, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})


---@param aPath path
---@return dofile
function _dofile.New(aPath) -- path: aPath
  local self = setmetatable({}, _dofile)
  self.m_name = aPath:Stem():ToString()
  self.m_path = aPath
  self.m_formated_name = helper.format_name(self.m_name)
  return self
end

-- methods

function _dofile.GetName(self)
  return self.m_name
end

function _dofile.GetPath(self)
  return self.m_path
end

function _dofile.GetFormatedName(self)
  return self.m_formated_name
end

function _dofile.Run(self)
  dofile(self.m_path:ToString())
end

return _dofile