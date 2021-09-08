local filesystem = {}

function filesystem.OpenFolder(aPath) -- path: aPath
  os.execute("start explorer " .. aPath:ToWinExcFormat())
end

function filesystem.FileExists(aPath) -- path: aPath
  local f=io.open(aPath:ToString(),"r")
  if (f~=nil) then io.close(f) return true else return false end
end

function filesystem.List(aPath, aListFile, aFilter) -- path: aPath, bool: aListFile, array<string>: aFilter
  local olist = {}
  -- list both files and dirs when aListFile == nil
  local mode = ""
  if aListFile == true then
    mode = "/a-d"
  elseif aListFile == false then
    mode = "/ad"
  end

  -- concat path with filter
  local path = ""

  if aFilter == nil then
    path = string.format([["%s"]], aPath:ToWinFormat())
  elseif type(aFilter) == "table" then
    for _, entry in ipairs(aFilter) do
        path = string.format([[%s "%s\*%s"]], path, aPath:ToWinFormat(), entry)
    end
  end

  local cmd = ""

  if aListFile == nil and type(aFilter) == "table" then
    cmd = string.format([[dir "%s" /b /ad && dir %s /b /a-d]], aPath:ToWinFormat(), path)
  else
    cmd = string.format([[dir %s /b %s]], path, mode)
  end

  local shell_handle = io.popen(cmd)
	for entry in shell_handle:lines() do
    table.insert(olist, aPath / entry)
	end
	shell_handle:close()
  return olist
end

return filesystem