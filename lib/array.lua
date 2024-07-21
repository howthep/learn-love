local proto=require('prototype')
local Array=proto{name='Array'}
local unp=require("version").unp

function Array:new(...)
    -- input can be number,string,table... 
    local args={...}
    if #args == 1 then
        args=args[1]
    end
    for i,v in ipairs(args) do
        local typ=type(v)
        if typ=="table" and v.name==nil then
            self:push(Array(unp(v)))
        else
            self:push(v)
        end
    end
end
function Array:map(func)
    local re=Array{}
    for i,v in ipairs(self) do
        re[i]=func(v,i,self)
    end
    return re
end
function Array:each(func)
    for i,v in ipairs(self) do
        func(v,i,self)
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
    -- pop at end
    return table.remove(self)
end
function Array:shift(x)
    -- push at head
    table.insert(self,1,x)
end
function Array:unshift()
    -- pop at head
    return table.remove(self,1)
end
function Array:exist(func)
    -- check if at least one item satisfies condition
    for i,v in ipairs(self) do
        local bool=func(v,i,self)
        if bool==true then
            return true
        end
    end
    return false
end
return Array