table.merge=function (t,p)
    -- only add nonexist key
    for k,v in pairs(p) do
        if not rawget(t,k) then
            t[k]=v
        end
    end
end
table.update=function (t,p)
    -- update all key, existing or nonexisting
    for k,v in pairs(p) do
        t[k] = v
    end
end

local prototype={}
prototype.__index=prototype
prototype.name='prototype'
function prototype:new(t)
    -- print('prototype new')
    table.merge(self,t or {})
end
function prototype:__tostring()
    local ret=string.format('{%s}\n',self.name)
    for k,v in pairs(self) do
        ret=ret..string.format('%s: %s\n',k,v)
    end
    return string.sub(ret,1,-2)
end
function prototype:is(T)
    local mt =getmetatable(self)
    while mt do
        if mt == T then
            return true
        end
        mt=getmetatable(mt)
    end
    return false
end
prototype=setmetatable(prototype, {
    __call=function (t, ...)
        local mt=getmetatable(t)
        local o =setmetatable({},t)
        t.__call=mt.__call
        t.__index=t
        t.__tostring=t.__tostring or mt.__tostring
        o.super=t.new
        t.new(o,...)
        return o
    end,
}
)
local function test()
    local people = prototype { name = 'people' }
    function people:new(t)
        people.super(self, t)
    end

    local student = people { name = 'student' }
    function student:new(t)
        student.super(self, t)
    end

    local a = student({ name = 'student' })
    print(a:is(prototype))
end
return prototype