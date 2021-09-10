local helper = require ("scripts/core/helper")

-- dofile class

local _dofile = {}
_dofile.__index = _dofile

-- dofile constructor

setmetatable(_dofile, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

function _dofile.New(aPath) -- path: aPath
  local self = setmetatable({}, _dofile)
  self.name = aPath:Stem():ToString()
  self.path = aPath
  self.formated_name = helper.format_name(self.name)
  return self
end

-- methods

function _dofile.GetName(self)
  return self.name
end

function _dofile.GetPath(self)
  return self.path
end

function _dofile.GetFormatedName(self)
  return self.formated_name
end

function _dofile.Run(self)
  dofile(self.path:ToString())
end

return _dofile