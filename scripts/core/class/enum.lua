-- enum class

local enum = {}
enum.__index = enum

-- enum constructor

setmetatable(enum, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

function enum.New(aEnum)
  local self
  local enum_new = {}

  enum_new.__STRING = {} -- Add string

  -- if aEnum is array then create default index
  if aEnum[1] then
    enum_new.__COUNT = #aEnum -- Add count
    for i, v in ipairs(aEnum) do
      enum_new[v] = i
    end
    enum_new.__STRING = aEnum
  else
    enum_new.__COUNT = 0
    for i, v in pairs(aEnum) do
      enum_new[i] = v
      enum_new.__STRING[v] = i
      enum_new.__COUNT = enum_new.__COUNT + 1
    end
  end

  self = setmetatable(enum_new, enum)
  return self
end

-- enum methods

function enum.ToString(self, aItem)
  return self.__STRING[aItem]
end

function enum.Count(self)
  return self.__COUNT
end

return enum