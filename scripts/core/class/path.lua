-- path class

local path = {}
path.__index = path

-- private functions

local function sanitize_path(aPath)
  local sanitized_path = aPath:gsub("\\", "/")
  return sanitized_path
end

-- path constructor

setmetatable(path, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

function path.New(aPath)
  local self = setmetatable({}, path)
  self.path = sanitize_path(aPath)
  return self
end

-- path methods

function path.__div (lhs, rhs)
  local new_path = (type(lhs) == "string" and sanitize_path(lhs) or lhs:ToString()) .. "/" .. (type(rhs) == "string" and sanitize_path(rhs) or rhs:ToString())
  return path(new_path)
end

function path.ToString(self)
  return self.path
end

function path.ToWinFormat(self)
  local win_formated = self.path:gsub("/", "\\")
  return win_formated
end

function path.ToWinExcFormat(self)
  local win_excformated = self.path:gsub("/", "\\\\")
  return win_excformated
end

function path.Append(self, aPath)
  local new_path = self.path .. "/" .. aPath
  return path(new_path)
end

function path.ParentPath(self)
  local parent_path
  if self.path == "/" then
    parent_path = self.path
  elseif self.path:find("/$") then
    parent_path = self.path:gsub("/[^/]-/$", "")
  else
    parent_path = self.path:gsub("/[^/]-$", "")
  end
  return path(parent_path)
end

function path.FileName(self)
  local file_name = self.path:gsub(".*/", "")
  return path(file_name)
end

function path.Stem(self)
  local stem
  local file_name = self:FileName():ToString()
  if file_name:find("^%.[^%.]*$") then
    stem = file_name
  else
    stem = file_name:gsub("%.[^%.]-$", "")
  end
  return path(stem)
end

function path.Extension(self)
  local file_name = self:FileName():ToString()
  local extension = file_name:match("%.[^%.]*$")
  return path(extension)
end

function path.HasExtension(self)
  local file_name = self:FileName():ToString()
  return file_name:find("%.[^%.]*$") and true or false
end

return path