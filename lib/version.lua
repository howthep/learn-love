local version=string.sub(_VERSION,string.len(_VERSION))+0
local unp
if version>1 then
   unp= function (x)
---@diagnostic disable-next-line: deprecated
    return table.unpack(x)
   end
else
    unp = function (x)
        return unpack(x)
    end
end
local export={
    version=version,
    unp=unp
}
return export