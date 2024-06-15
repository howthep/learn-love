local Object=require("classic")
local Array=Object:extend()
local unp=function () end

if require('version')>1 then
   unp= function (x)
    return table.unpack(x)
   end
else
    unp = function (x)
        return unpack(x)
    end
end
function Array:new(...)
    -- input can be number,string,table... 
    local args={...}
    self.type="array"
    self.data={}
    for i,v in ipairs(args) do
        local typ=type(v)
        if typ=="table" then
            self:push(Array(unp(v)))
        else
            self:push(v)
        end
    end
end
function Array:__index(key)
    for k,v in pairs(self)do
        print(k,v)
    end
    print('key is ',key)
    print(2,rawget(self,key))
    print(3,rawget(self,'super'))
   return rawget(self,key)  or self.super[key]
end
function Array:__len()
    return #self.data
end
function Array:get(k)
    -- return rawget(self.data,k)
    return self.data[k]
end
function Array:__tostring()
    local res=""
    local items={}
    for i,v in ipairs(self.data) do
        local str=string.format("%s",v)
        table.insert(items,str)
    end
    return string.format("Array( %s )",table.concat(items,", "))
end
function Array:__add(add)
    
end
function Array:__mul(n_repeat)
    
end

function Array:push(x)
    -- push to end
    table.insert(self.data,x)
end
function Array:pop()
    -- pop at end
    
end
function Array:shift()
    -- push at head
    
end
function Array:unshift()
    -- pop at head
    
end
return Array