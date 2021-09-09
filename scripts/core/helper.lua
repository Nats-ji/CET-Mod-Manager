local helper = {}

function helper.format_name(aName)
	if string.find(aName, "_") then
		return string.gsub(" "..string.gsub(aName, "_" , " "), "%W%l", string.upper):sub(2)
	elseif string.find(aName, "-") then
		return string.gsub(" "..string.gsub(aName, "-" , " "), "%W%l", string.upper):sub(2)
	else
		return string.gsub(" "..aName, "%W%l", string.upper):sub(2)
	end
end

-- https://gist.github.com/haggen/2fd643ea9a261fea2094#gistcomment-2339900
function helper.randomHash(length)
	local charset = {}  do -- [0-9a-zA-Z]
		for c = 48, 57  do table.insert(charset, string.char(c)) end
		for c = 65, 90  do table.insert(charset, string.char(c)) end
		for c = 97, 122 do table.insert(charset, string.char(c)) end
	end
	if not length or length <= 0 then return '' end
	math.randomseed(os.clock()^5)
	return helper.randomHash(length - 1) .. charset[math.random(1, #charset)]
end

-- http://lua-users.org/wiki/OverloadedFunctions
function helper.overloaded()
  local fns = {}
  local mt = {}

  local function oerror()
    return error("Invalid argument types to overloaded function")
  end

  function mt:__call(...)
    local arg = {...}
    local default = self.default

    local signature = {}
    for i, arg in ipairs {...} do
      signature[i] = type(arg)
    end

    signature = table.concat(signature, ",")

    return (fns[signature] or self.default)(...)
  end

  function mt:__index(key)
    local signature = {}
    local function __newindex(self, key, value)
      signature[#signature + 1] = key
      fns[table.concat(signature, ",")] = value
    end
    local function __index(self, key)
      signature[#signature + 1] = key
      return setmetatable({}, {__index = __index, __newindex = __newindex})
    end
    return __index(self, key)
  end

  function mt:__newindex(key, value)
    fns[key] = value
  end

  return setmetatable({default = oerror}, mt)
end

return helper