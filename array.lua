local Object=require("classic")
local Array=Object:extend()
local unp=require("version").unp

function Array:new(...)
    -- input can be number,string,table... 
    local args={...}
    self.type="array"
    for i,v in ipairs(args) do
        local typ=type(v)
        if typ=="table" then
            self:push(Array(unp(v)))
        else
            self:push(v)
        end
    end
end
function Array:__tostring()
    local res=""
    local items={}
    for i=1,#self  do
        local v=self[i]
        local str=string.format("%s",v)
        table.insert(items,str)
    end
    return string.format("Array( %s )",table.concat(items,", "))
end
function Array:__add(add)
    -- onyly for Array + add, not for add + Array
    if type(add)=='table' then
        for index, value in ipairs(add) do
            self:push(value)
        end
    else
            self:push(add)
    end
    return self
end
function Array:__mul(n_repeat)
    
end

function Array:push(x)
    -- push to end
    table.insert(self,x)
end
function Array:pop()
    return table.remove(self)
    -- pop at end
end
function Array:shift(x)
    -- push at head
    table.insert(self,1,x)
end
function Array:unshift()
    -- pop at head
    return table.remove(self,1)
end
return Array