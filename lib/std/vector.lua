local ptt=require('prototype')

--- prototype of all vector, such as position color 
---@class Vector :prototype
local Vector=ptt{name='Vector'}
local Array=require('array')
local FP=require('FP')
function Vector:new(config)
    config = config or {
        name = 'Unknown Vector', 
        default = { x = 0, y = 0 }
    }
    self.name=config.name
    local default=config.default
    self.keys=Array(table.keys(default))
    self:merge(default)
end
function Vector:map(func)
    local new_v=self:clone()
    new_v.keys:each(function (k)
       new_v[k]=func(new_v[k],k,self)
    end)
    return new_v
end
function Vector:reduce(func,init_value)
    return self.keys:reduce(function (accumulator,key)
        return func(accumulator,self[key])
    end,init_value)
end
function Vector:__add(v)
    return self:map(function (value,key)
        local mul_num=type(v)=="number" and v or v[key]
        return value+mul_num
    end)
end
function Vector:__sub(new_vec)
    return self+new_vec*-1
end
---set all value to number
---@param number number
function Vector:set_all(number)
    self.keys:each(function (key)
       self[key]=number
    end)
end
function Vector:__mul(v)
    if type(v)=="number"then
        local num=v
        v=self:clone()
        v:set_all(num)
    end
    return self:map(function (value,key)
        local mul_num= v[key]
        return value*mul_num
    end)
end
function Vector:__div(v)
    if type(v)=='number' then
        v=1/v
        return self * v
    else
        return self * v:invert()
    end
end
function Vector:__unm()
    return self*-1
end
---invert all value, Vec(2,3) => Vec(1/2,1/3)
function Vector:invert()
    if self.keys:exist(function (key)
        return FP.is_zero(self[key])
    end) then
        error(tostring(self)..' has 0 value')
    end
    return self:map(function (value)
        return 1/value
    end)
end
function Vector:__tostring()
    local fmt='%s( %s )'
    local s=self.keys:map(function (key)
        return string.format('%s: %s',key,self[key])
    end)
    local str=string.format(fmt,self.name,s:join())
    return str
end
function Vector:kv_table()
    local t={}
    self.keys:each(function (key)
        t[key]=self[key]
    end)
    return t
end
function Vector:clone()
    local super=getmetatable(self)
    local new_v= super()
    table.update(new_v,self:kv_table())
    return new_v
end
function Vector:__concat(strin)
    return tostring(self)..strin
end
---return length of vector
---@return number len
function Vector:len()
    local square_sum=self:reduce(function (sum,value)
        return sum+value*value
    end)
    return math.sqrt(square_sum)
end
function Vector:distance(vec)
    return (self-vec):len()
end
function Vector:sum()
    return self:reduce(function (sum,v)
        return sum+v
    end,0)
end
function Vector:normal()
    local len=self:len()
    if len==0 then
        return self
    else
        return self/len
    end
end
function Vector:sign()
    return self:map(FP.sign)
end
function Vector:abs()
    return self:map(math.abs)
end
function Vector:__eq(v)
    return self.keys:every(function (key)
        return self[key]==v[key]
    end)   
end
return Vector