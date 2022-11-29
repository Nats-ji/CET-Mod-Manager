---@class baseTheme
---@operator call(string):baseTheme
local baseTheme = {
    name = "default",
    colors = {},
}
baseTheme.__index = baseTheme

-- baseTheme constructor

setmetatable(baseTheme, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})


---@param aName string
---@return baseTheme
function baseTheme.New(aName) -- path: aPath
  local self = setmetatable({}, baseTheme)
  self.name = aName or self.name
  return self
end

-- methods
function baseTheme.GetName(self)
  return self.name
end

---Safe call method
---@param self baseTheme
---@param aMethod string
---@param ... any
---@return any
function baseTheme.Call(self, aMethod, ...)
  if self[aMethod] then
    return self[aMethod](self, ...)
  end
end

---Only call method in specific theme
---@param self baseTheme
---@param aThemeName string
---@param aMethod string
---@param ... any
---@return any
function baseTheme.CallIf(self, aThemeName, aMethod, ...)
  if self.name == aThemeName and self[aMethod] then
    return self[aMethod](self, ...)
  end
end

---@param self baseTheme
---@param aGuiColor string
---@return float[]
function baseTheme.GetStyleColor(self, aGuiColor)
    return self.colors[aGuiColor]
end

return baseTheme