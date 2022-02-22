-- Path class

---@class path
---@field m_path string
local path = {}
path.__index = path

-- private functions

---@param aPath string
---@return string
local function sanitize_Path(aPath)
  local sanitized_Path = aPath:gsub("\\", "/")
  return sanitized_Path
end

-- Path constructor

setmetatable(path, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

---@param aPath string
---@return path
function path.New(aPath)
  local self = setmetatable({}, path)
  self.m_path = sanitize_Path(aPath)
  return self
end

-- Path methods

---Path "/" operator
---@param lhs string|path
---@param rhs string|path
---@return path
function path.__div (lhs, rhs)
  local new_path = (type(lhs) == "string" and sanitize_Path(lhs) or lhs:ToString()) .. "/" .. (type(rhs) == "string" and sanitize_Path(rhs) or rhs:ToString())
  return path.New(new_path)
end

function path.ToString(self)
  return self.m_path
end

function path.ToWinFormat(self)
  local win_formated = self.m_path:gsub("/", "\\")
  return win_formated
end

function path.ToWinExcFormat(self)
  local win_excformated = self.m_path:gsub("/", "\\\\")
  return win_excformated
end

function path.Append(self, aPath)
  local new_path = self.m_path .. "/" .. aPath
  return path.New(new_path)
end

function path.ParentPath(self)
  local parent_Path
  if self.m_path == "/" then
    parent_Path = self.m_path
  elseif self.m_path:find("/$") then
    parent_Path = self.m_path:gsub("/[^/]-/$", "")
  else
    parent_Path = self.m_path:gsub("/[^/]-$", "")
  end
  return path.New(parent_Path)
end

function path.FileName(self)
  local file_name = self.m_path:gsub(".*/", "")
  return path.New(file_name)
end

function path.Stem(self)
  local stem
  local file_name = self:FileName():ToString()
  if file_name:find("^%.[^%.]*$") then
    stem = file_name
  else
    stem = file_name:gsub("%.[^%.]-$", "")
  end
  return path.New(stem)
end

function path.Extension(self)
  local file_name = self:FileName():ToString()
  local extension = file_name:match("%.[^%.]*$")
  return path.New(extension)
end

function path.HasExtension(self)
  local file_name = self:FileName():ToString()
  return file_name:find("%.[^%.]*$") and true or false
end

return path